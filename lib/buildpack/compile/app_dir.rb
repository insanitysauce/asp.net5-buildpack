# Encoding: utf-8
# ASP.NET 5 Buildpack
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module AspNet5Buildpack
  class AppDir
    DEPLOYMENT_FILE_NAME = '.deployment'.freeze

    def initialize(dir, out)
      @dir = dir
      @out = out
    end

    def root
      @dir
    end

    def release_yml_path
      File.join(@dir, 'aspnet5-buildpack-release.yml')
    end

    def startup_script_path
      File.join(@dir, '.profile.d', 'startup.sh')
    end

    def with_command(cmd)
      with_project_json.select { |d| !commands(d)[cmd].nil? && commands(d)[cmd] != '' }
    end

    def with_project_json
      Dir.glob(File.join(@dir, '**', 'project.json')).map do |d|
        Pathname.new(File.dirname(d)).relative_path_from(Pathname.new(@dir))
      end
    end

    def project_json(dir)
      File.join(@dir, dir, 'project.json')
    end

    def commands(dir)
      JSON.load(IO.read(project_json(dir), encoding: 'bom|utf-8')).fetch('commands', {})
    end

    def deployment_file_project
      paths = with_project_json
      deployment_file = File.expand_path(File.join(@dir, DEPLOYMENT_FILE_NAME))
      File.foreach(deployment_file) do |line|
        m = /project = (.*)/.match(line)
        if m
          path = Pathname.new(m[1])
          return path if paths.include?(path)
        end
      end if File.exist?(deployment_file)
      nil
    end
  end
end
