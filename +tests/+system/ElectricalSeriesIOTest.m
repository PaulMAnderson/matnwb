classdef ElectricalSeriesIOTest < tests.system.PyNWBIOTest
    methods(Test)
        function testOutToPyNWB(testCase)
            testCase.assumeFail(['Current schema in MatNWB does not include a ElectrodeTable class used by Python tests. ', ...
                'When it does, addContainer in this test will need to be updated to match the Python test']);
        end
        
        function testInFromPyNWB(testCase)
            testCase.assumeFail(['Current schema in MatNWB does not include a ElectrodeTable class used by Python tests. ', ...
                'When it does, addContainer in this test will need to be updated to match the Python test']);
        end
    end
    
    methods
        function addContainer(testCase, file) %#ok<INUSL>
            devnm = 'dev1';
            egnm = 'tetrode1';
            esnm = 'test_eS';
            devloc = ['/general/devices/' devnm];
            egloc = ['/general/extracellular_ephys/' egnm];
            etloc = '/general/extracellular_ephys/electrodes';
            dev = types.core.Device( ...
                'source', 'a test source');
            file.general_devices.set(devnm, dev);
            eg = types.core.ElectrodeGroup( ...
                'source', 'a test source', ...
                'description', 'tetrode description', ...
                'location', 'tetrode location', ...
                'device', types.untyped.SoftLink(devloc));
            et = types.core.ElectrodeTable(...
                'data', struct2table(struct(...
                    'id', int64(1), 'x', rand(), 'y', rand(), 'z', rand(), ...
                    'imp', rand(), 'location', {{''}}, 'filtering', {{''}}, ...
                    'description', {{'test'}}, 'group', types.untyped.ObjectView(egloc), ...
                    'group_name', {{'tetrode1'}}))...
                );
            file.general_extracellular_ephys.set('electrodes', et);
            file.general_extracellular_ephys.set(egnm, eg);
            es = types.core.ElectricalSeries( ...
                'source', 'a hypothetical source', ...
                'data', int32([0:9;10:19]) .', ...
                'timestamps', (0:9) .', ...
                'electrodes', types.core.ElectrodeTableRegion(...
                'data', types.untyped.RegionView(etloc, 1, 1)));
            file.acquisition.set(esnm, es);
        end
        
        function c = getContainer(testCase, file) %#ok<INUSL>
            c = file.acquisition.get('test_eS');
        end
    end
end

