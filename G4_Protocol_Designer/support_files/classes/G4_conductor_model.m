classdef G4_conductor_model < handle
    
    properties
        
        fly_name_;
        fly_genotype_;
        experimenter_;
        fly_age_;
        fly_sex_;
        experiment_temp_;
        experiment_type_;
        rearing_protocol_
        do_plotting_;
        do_processing_;
        plotting_file_;
        processing_file_;
        run_protocol_file_;
        google_sheet_key_;
        list_of_gids_;
        metadata_array_
        metadata_options_
       num_tests_conducted_
        
    end
    
    properties (Dependent)
        
        fly_name;
        fly_genotype;
        fly_age;
        fly_sex;
        experiment_temp;
        experimenter;
        rearing_protocol
        experiment_type;
        do_plotting;
        do_processing;
        plotting_file;
        processing_file;
        run_protocol_file;
        google_sheet_key;
        list_of_gids
        metadata_array
        metadata_options
        num_tests_conducted
    end
    
    
    methods
        
%CONSTRUCTOR--------------------------------------------------------------

        function self = G4_conductor_model()
            
            %%User adjusted lists based on settings file and metadata google sheet
            list_of_setting_strings = {'Default run protocol file: ', 'Default processing file: ', ...
                'Default plotting file: ', 'Metadata Google Sheet key: '}; %These strings must match the string
            %preceding the corresponding value in the settings file -
            %including the space after the :
            
            %These strings must match the class property names they
            %correspond to.
            list_of_settings_needed = {'run_protocol_file', 'processing_file', 'plotting_file', 'google_sheet_key'};
            
            for i = 1:length(list_of_setting_strings)
                [settings_data, path, index] = self.get_setting(list_of_setting_strings{i});
                self.(list_of_settings_needed{i}) = strtrim(settings_data{path}(index:end));
            end
            
            %This list must be in the same order as the gid strings list. 
            list_of_metadata_fields = {'experimenter', 'fly_age', 'fly_sex', 'fly_geno', 'exp_temp', 'rearing'};
           
            list_of_gid_strings = {'Users Sheet GID: ','Fly Age Sheet GID: ', 'Fly Sex Sheet GID: ', ...
                'Fly Geno Sheet GID: ', 'Experiment Temp Sheet GID: ', 'Rearing Protocol Sheet GID: '};
            self.list_of_gids = {};
            for i = 1:length(list_of_gid_strings)
                [settings_data, path, index] = self.get_setting(list_of_gid_strings{i});
                self.list_of_gids{i} = strtrim(settings_data{path}(index:end));
            end

            %%run functions to 1)read the metadata options from the google
            %%sheet and 2) create a metadata_lists cell array with the list
            %%of options for each metadata field. 
            self.get_metadata_array();
            self.create_metadata_options(list_of_metadata_fields);
            
            %%Set initial values of properties - default to first item on
            %%each metadata list.
            self.fly_name = '';
            self.fly_genotype = self.metadata_options.fly_geno{1};
            self.fly_age = self.metadata_options.fly_age{1};
            self.fly_sex = self.metadata_options.fly_sex{1};
            self.experiment_temp = self.metadata_options.exp_temp{1};
            self.experimenter = self.metadata_options.experimenter{1};
            self.rearing_protocol = self.metadata_options.rearing{1};
            self.experiment_type = 1;
            self.do_plotting = 1;
            self.do_processing = 1;
           
            
            
            
        end
        
        %%methods
        
        function get_metadata_array(self)
        
            %Use GetGoogleSpreadsheet to get a cell array of each sheet.
            
            self.metadata_array = {};
            for i = 1:length(self.list_of_gids)
                self.metadata_array{i} = GetGoogleSpreadsheet(self.google_sheet_key, self.list_of_gids{i});
            end
            
        end

        %Get the index of a desired metadata heading from the google sheet------  
        function create_metadata_options(self, list)
            
            for i = 1:length(list)

                self.metadata_options.(list{i}) = self.metadata_array{i}(2:end,1);
            end
            
        end

        
        function [settings_data, path, index] = get_setting(self, string_to_find)
            last_five = string_to_find(end-5:end);
            settings_data = strtrim(regexp( fileread('G4_Protocol_Designer_settings.m'),'\n','split'));
            path = find(contains(settings_data, string_to_find));
            index = strfind(settings_data{path},last_five) + 5;
        
        end
        
        
        
        
        
%GETTERS------------------------------------------------------------------
        
        function value = get.fly_name(self)
            value = self.fly_name_;
        end
        
        function value = get.fly_genotype(self)
            value = self.fly_genotype_;
        end
        
        function value = get.experimenter(self)
            value = self.experimenter_;
        end
        
        function value = get.experiment_type(self)
            value = self.experiment_type_;
        end
        
        function value = get.do_plotting(self)
            value = self.do_plotting_;
        end
        
        function value = get.do_processing(self)
            value = self.do_processing_;
        end
        
        function value = get.plotting_file(self)
            value = self.plotting_file_;
        end
        
        function value = get.processing_file(self)
            value = self.processing_file_;
        end
        
        function value = get.run_protocol_file(self)
            value = self.run_protocol_file_;
        end
        
        function value = get.fly_age(self)
            value = self.fly_age_;
        end
        
        function value = get.fly_sex(self)
            value = self.fly_sex_;
        end
        function value = get.experiment_temp(self)
            value = self.experiment_temp_;
        end
        function output = get.metadata_array(self)
            output = self.metadata_array_;
        end
        
   
        function value = get.google_sheet_key(self)
            value = self.google_sheet_key_;
        end
        
        function output = get.num_tests_conducted(self)
            output = self.num_tests_conducted_;
        end
        
        function output = get.list_of_gids(self)
            output = self.list_of_gids_;
        end
        function output = get.metadata_options(self)
            output = self.metadata_options_;
        end
        function output = get.rearing_protocol(self)
            output = self.rearing_protocol_;
        end
            


%SETTERS------------------------------------------------------------------

        function set.fly_name(self, value)
            self.fly_name_ = value;
        end
        
        function set.fly_genotype(self, value)
            self.fly_genotype_ = value;
        end
        
        function set.experimenter(self, value)
            self.experimenter_ = value;
        end
        
        function set.experiment_type(self, value)
            self.experiment_type_ = value;
        end
        
        function set.do_plotting(self, value)
            self.do_plotting_ = value;
        end
        
        function set.do_processing(self, value)
            self.do_processing_ = value;
        end
        
        function set.plotting_file(self, value)
            self.plotting_file_ = value;
        end
        
        function set.processing_file(self, value)
            self.processing_file_ = value;
        end
        
        function set.run_protocol_file(self, value)
            self.run_protocol_file_ = value;
        end
        function set.fly_age(self, value)
            self.fly_age_ = value;
        end
        function set.fly_sex(self, value)
            self.fly_sex_ = value;
        end
        function set.experiment_temp(self, value)
            self.experiment_temp_ = value;
        end
        function set.metadata_array(self, value)
            self.metadata_array_ = value;
        end

        
        function set.google_sheet_key(self, value)
            self.google_sheet_key_ = value;
        end
        
        function set.num_tests_conducted(self, value)
            self.num_tests_conducted_ = value;
        end
        
        function set.list_of_gids(self, value)
            self.list_of_gids_ = value;
        end

        function set.metadata_options(self, value)
            self.metadata_options_ = value;
        end
        
        function set.rearing_protocol(self, value)
            self.rearing_protocol_ = value;
        end
        
       
    end
    
    
end