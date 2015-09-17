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

require_relative 'app_dir'

module AspNet5Buildpack
  class DNU
    def initialize(shell)
      @shell = shell
    end

    def restore(dir, out)
      @shell.env['HOME'] = dir
      @shell.env['MONO_THREADS_PER_CPU'] = '2000'
      @shell.path << '/app/mono/bin'
      project_list = AppDir.new(dir, out).with_project_json.join(' ')
      cmd = "bash -c 'source #{dir}/.dnx/dnvm/dnvm.sh; dnvm use default -r mono -a x64; cd #{dir}; dnu restore -p http://fwproxy.ldschurch.org:80 #{project_list}'"
      @shell.exec(cmd, out)
    end
  end
end
