# Encoding: utf-8
# ASP.NET 5 Buildpack
# Copyright 2014-2015 the original author or authors.
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
  class Detecter
    def detect(dir)
      nuget_config_exists?(dir) && project_json_exists?(dir)
    end

    private

    def nuget_config_exists?(dir)
      File.exist? File.join(dir, 'NuGet.Config')
    end

    def project_json_exists?(dir)
      !Dir.glob(File.join(dir, '**', 'project.json')).empty?
    end
  end
end
