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

require 'rspec'
require 'tmpdir'
require_relative '../../lib/buildpack.rb'

describe AspNet5Buildpack::Detecter do
  let(:dir) do
    Dir.mktmpdir
  end

  describe 'detect' do
    context 'when there is no NuGet.Config in the root directory' do
      before do
        File.open(File.join(dir, 'project.json'), 'w') { |f| f.write('a') }
      end

      it 'returns false' do
        expect(subject.detect(dir)).to be_falsey
      end
    end

    context 'when there is no project.json' do
      before do
        File.open(File.join(dir, 'NuGet.Config'), 'w') { |f| f.write('a') }
      end

      it 'returns false' do
        expect(subject.detect(dir)).to be_falsey
      end
    end

    context 'when project.json and NuGet.Config exist in the same directory' do
      before do
        File.open(File.join(dir, 'NuGet.Config'), 'w') { |f| f.write('a') }
        File.open(File.join(dir, 'project.json'), 'w') { |f| f.write('a') }
      end

      it 'returns true' do
        expect(subject.detect(dir)).to be_truthy
      end
    end

    context 'when project.json and NuGet.Config exist in different directories' do
      before do
        File.open(File.join(dir, 'NuGet.Config'), 'w') { |f| f.write('a') }
        FileUtils.mkdir_p(File.join(dir, 'src', 'proj'))
        File.open(File.join(dir, 'src', 'proj', 'project.json'), 'w') { |f| f.write('a') }
      end

      it 'returns true' do
        expect(subject.detect(dir)).to be_truthy
      end
    end
  end
end
