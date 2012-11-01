

curr_dir = uigetdir;
mtrfiles = dir(sprintf('%s/*.mtr',curr_dir));
% all_props =
% struct('Arc',{},'Dend',{},'uns2',{},'uns',{},'unk',{},'unf',{},'komisch',{});
all_trees = cell(0);
for f = 1:numel(mtrfiles)
    curr_file = load_tree(fullfile(curr_dir,mtrfiles(f).name));
    if iscell(curr_file) && numel(curr_file) == 1
        curr_file = curr_file{1};
    end
    curr_file = curr_file(cellfun(@(x)  numel(x.X),curr_file)>10);  % sort out uncompleted trees
    for t = 1:numel(curr_file)
        curr_props = strread(curr_file{t}.name,'%s','delimiter','_');
        if ~isempty(cell2mat(strfind(curr_props,'pos')))
            curr_file{t}.Arc = true;
        else
            curr_file{t}.Arc = false;
        end
        if ~isfield(curr_file{t}, 'Arc')
            'g'
        end
        if ~isempty(cell2mat(strfind(curr_props,'unsicher')))
            curr_file{t}.uns = true;
        else
            curr_file{t}.uns = false;
        end
        if ~isempty(cell2mat(strfind(curr_props,'unsicher2')))
            curr_file{t}.uns2 = true;
        else
            curr_file{t}.uns2 = false;
        end
        if ~isempty(cell2mat(strfind(curr_props,'unkomplett')))
            curr_file{t}.unk = true;
        else
            curr_file{t}.unk = false;
        end
        if ~isempty(cell2mat(strfind(curr_props,'unfertig')))
            curr_file{t}.unf = true;
        else
            curr_file{t}.unf = false;
        end
        if ~isempty(cell2mat(strfind(curr_props,'komisch')))
            curr_file{t}.komisch = true;
        else
            curr_file{t}.komisch = false;
        end
        if ~isempty(cell2mat(regexp(curr_props,'\dv\d')))
            curr_file{t}.Dend = cell2mat(textscan(curr_props{~cellfun(@isempty,(regexp(curr_props,'\dv\d')))},'%dv%dd'));
        else
            curr_file{t}.Dend = [];
        end
    end
            all_trees(end+1:end+numel(curr_file)) = curr_file;
end
