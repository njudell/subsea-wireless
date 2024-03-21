FileName = 'parameters_original.json';
fid = fopen(FileName,'r');
raw=fread(fid,inf);
str = char(raw');
fclose(fid);
data=jsondecode(str);
%re-sort data by id
ids = zeros(length(data.all),1);
for i=1:length(data.all)
    dx = data.all{i};
    ids(i) = dx.id;
end
[~,order] = sort(ids);
allStuff = data.all(order);
%now, it turns out that command 29 is incorrect, and all commands after
%that in numerical order are off by one, so let's fix that.
mostStuff = cell(size(allStuff,1),1);
badCode = 29;
count = 1;
ids=[];
for i = 1:size(allStuff,1)
    trial = allStuff{i};
    if trial.id ~= badCode
        if (trial.id > badCode) && trial.id < 129
            trial.id = trial.id - 1;
        end
    else
        trial.id = 128;
    end
    mostStuff{trial.id} = trial;
end
dataSorted.all = mostStuff;
strSorted = jsonencode(dataSorted,'PrettyPrint',true);
FileName = 'parameters.json';
fid = fopen(FileName,'w');
fprintf(fid,'%s',strSorted);
fclose(fid);


