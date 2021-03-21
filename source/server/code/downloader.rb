# frozen_string_literal: true
require 'json'

class Downloader

  def initialize(externals)
    @externals = externals
  end

  def download(id:)
    if !model.kata_exists?(id)
      fail "Cannot find a practice session with id #{id}"
    end
    manifest = model.kata_manifest(id)
    created = manifest['created']
    disk.tmp_dir(id, '/tmp') do |tmp_dir|
      dir_name = "cyber-dojo-#{at(created)}-#{id}"
      git_dir = "#{tmp_dir}/#{dir_name}"
      git_init(git_dir)
      events = model.kata_events(id)
      events.each do |e|
        index = e['index']
        event = model.kata_event(id, index)
        save_event(git_dir, id, event)
        git_commit(git_dir, index)
      end
      tgz(tmp_dir, dir_name, id)
    end
  end

  private

  def save_event(git_dir, id, event)
    remove_all_content_from(git_dir, id)
    sandbox = {}
    files = event.delete('files')
    files.each do |pathed_filename,json|
      sandbox["sandbox/#{pathed_filename}"] = json['content']
    end
    save(git_dir, sandbox)
    sss = {}
    sss['stdout'] = event.delete('stdout')
    sss['stderr'] = event.delete('stderr')
    sss['status'] = event.delete('status')
    save(git_dir, sss)
    save(git_dir, { "event.json": event })
  end

  def at(t)
    "#{t[0]}-#{t[1]}-#{t[2]}"
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
      disk.write_txt("#{git_dir}/#{pathed_filename}", content)
    end
  end

  def git_init(git_dir)
    command = [
      "mkdir -vp #{git_dir}",
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
      "git commit --allow-empty --all --message #{index} --quiet",
      "git tag #{index} HEAD"
    ].join(' && ')
    shell.assert_exec(command)
  end

  def tgz(base_dir, git_dir, id)
    disk.tmp_dir(id, '/tmp') do |tmp_dir|
      tgz_filename = "#{tmp_dir}/#{git_dir}.tgz"
      command = "tar -C #{base_dir} -zcf #{tgz_filename} #{git_dir}"
      shell.assert_exec(command)
      ["#{git_dir}.tgz", disk.read_bin(tgz_filename)]
    end
  end

  # - - - - - - - - - - - - - - - - - - - -

  def disk
    @externals.disk
  end

  def model
    @externals.model
  end

  def shell
    @externals.shell
  end

end
