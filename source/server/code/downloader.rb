# frozen_string_literal: true

class Downloader

  def initialize(externals)
    @externals = externals
  end

  def download(id:)
    if !model.kata_exists?(id)
      fail "Cannot find a practice session with id #{id}"
    end
    disk.tmp_dir(id, '/tmp') do |git_dir|
      git_init(git_dir)
      events = model.kata_events(id)
      events.each do |e|
        index = e['index']
        event = model.kata_event(id, index)
        save_event(git_dir, id, event)
        git_commit(git_dir, index)
      end
      tgz_filename = "cyber-dojo-#{at}-#{id}"
      [ tgz_filename, tgz_bytes(git_dir, id) ]
    end
  end

  private

  def save_event(git_dir, id, event)
    remove_all_content_from(git_dir, id)
    sandbox = {}
    files = event.delete('files')
    files.each do |pathed_filename,content|
      sandbox["sandbox/{pathed_filename}"] = content
    end
    save(git_dir, sandbox)
    sss = {}
    sss['stdout'] = event.delete('stdout')
    sss['stderr'] = event.delete('stderr')
    sss['status'] = event.delete('status')
    save(git_dir, sss)
    save(git_dir, { "event.json": event })
  end

  def at
    t = Time.now
    year  = "%04d" % t.year
    month = "%02d" % t.month
    day   = "%02d" % t.day
    "#{year}-#{month}-#{day}"
  end

  def remove_all_content_from(git_dir, id)
    disk.tmp_dir(id, '/tmp') do |tmp_dir|
      shell.assert_exec(
        "mv #{git_dir}/.git #{tmp_dir}",
        "rm -rf #{git_dir}",
        "mkdir -p #{git_dir}",
        "mv #{tmp_dir}/.git #{git_dir}"
      )
    end
  end

  def save(git_dir, files)
    files.each do |pathed_filename, content|
      path = File.dirname(pathed_filename)
      source_dir = "#{git_dir}/#{path}"
      unless path === '.'
        shell.assert_exec("mkdir -vp #{source_dir}")
      end
      disk.write(source_dir, content)
    end
  end

  def git_init(git_dir)
    command = [
      "cd #{git_dir}",
      'git init --quiet',
      "git config user.name 'downloader'",
      "git config user.email 'downloader@cyber-dojo.org'"
    ].join(' && ')
    shell.assert_exec(command)
  end

  def git_commit(git_dir, index)
    command = [
      "cd #{git_dir}",
      'git add .',
      "git commit --allow-empty --all --message #{index} --quiet"
    ].join(' && ')
    shell.assert_exec(command)
  end

  def tgz_bytes(git_dir, id)
    dir.tmp_dir(id, '/tmp') do |tmp_dir|
      tgz_filename = "#{tmp_dir}/download.tgz"
      command = "tar -zcf #{tgz_filename} #{git_dir}"
      shell.assert_exec(command)
      disk.binread(tgz_filename)
    end
  end

  # - - - - - - - - - - - - - - - - - - - -

  def disk
    @external.disk
  end

  def model
    @externals.model
  end

  def shell
    @external.shell
  end

end
