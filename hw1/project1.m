%read data
test_path = './dataset/test/';
test_data_dir = dir(test_path);
train_path = './dataset/training/';
train_data_dir = dir(train_path);

%count for correctness
sad_correct = 0;
ssd_correct = 0;

%redundant length count
test_red = 0;

%loading bar
h = waitbar(0, 'please wait');

for i = 1:length(test_data_dir) %read test img
    
    test_name = test_data_dir(i).name; %fprintf('%s\n', test_name);
    if(isequal(test_name, '.') || isequal(test_name, '..') || isequal(test_name, '.DS_Store'))
        test_red = test_red + 1;
        continue;
    end
    test = imread(strcat(test_path, test_name));
    test = im2double(test);
    %[m, n] = size(test); %get img size
    %new_test = reshape(test, 1, m*n); %reshape img size
    
    %initial value
    sad_min = realmax('single');
    sad_name = '';
    ssd_min = realmax('single');
    ssd_name = '';
    
    for j = 1:length(train_data_dir) %read train img
        
        train_name = train_data_dir(j).name; %fprintf('%s\n', train_name);
        if(isequal(train_name, '.') || isequal(train_name, '..') || isequal(test_name, '.DS_Store'))
            continue;
        end
        train = imread(strcat(train_path, train_name));
        train = im2double(train);
        %[m, n] = size(train); %get img size
        %new_train = reshape(train, 1, m*n); %reshape img size
        
        %compute sad value
        sad = abs(test - train);
        sad_sum = sum(sad, 'all');
        if(sad_min > sad_sum)
            sad_min = sad_sum;
            sad_name = train_name;
        end
        
        %compute ssd value
        ssd = abs((test - train) .* (test - train));
        ssd_sum = sum(ssd, 'all');
        if(ssd_min > ssd_sum)
            ssd_min = ssd_sum;
            ssd_name = train_name;
        end
        
    end
    
    %strcat
    if(strncmp(test_name, 'm-00', 4))
        strcat('m', test_name);
    end
    
    %fprintf('test_name: %s\n', test_name);
    %fprintf('sad_name: %s\n', sad_name);
    %fprintf('ssd_name: %s\n', ssd_name);
    
    %update sad correct value
    if(strncmp(test_name, sad_name, 6))
        sad_correct = sad_correct + 1;
    end
    
    %update ssd correct value
    if(strncmp(test_name, ssd_name, 6))
        ssd_correct = ssd_correct + 1;
    end
    
    str=['processing...', num2str(i / length(test_data_dir) * 100), '%'];
    waitbar(i / length(test_data_dir), h, str)
    
end

%dalete bar
delete(h);

%compute sad result
sad_result = sad_correct / (length(test_data_dir) - test_red);
fprintf('sad = %3f\n', sad_result);

%compute ssd result
ssd_result = ssd_correct / (length(test_data_dir) - test_red);
fprintf('ssd = %3f\n', ssd_result);


