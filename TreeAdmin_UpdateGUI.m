function TreeAdmin_UpdateGUI(handles)
%    {'animal','dpi','HFS','lateral_side','pyramidal_blade','arc','complete
%    ness','xyz_scale','one_micron_sampling'}
if ~isfield(handles.admin,'all_trees')
    return
end

if numel(handles.admin.all_trees) > size(handles.admin.treecolors,1)
    handles.admin.treecolors = repmat(handles.admin.treecolors,[ceil(numel(handles.admin.all_trees)/size(handles.admin.treecolors,1)),1]);
end

if handles.filter.changed && ~handles.admin.locktreelist_ok
    handles.filter.changed = false;
    
    handles.filter.selected_trees = 1;
    set(handles.Trees,'Value',1)
    
    
    handles.admin.filter = false(numel(handles.admin.all_trees),1);
    
    for t = 1: numel(handles.admin.all_trees)
        if handles.admin.deleted_trees(t)
            handles.admin.filter(t) = false;
        else
            handles.admin.filter(t) = TreeAdmin_checktreewithfilter(handles.admin.all_trees{t},handles.filter);
        end
    end
end
%     %% dpi check
%     %     dpi = cellfun(@(x) x.dpi,handles.admin.all_trees);%,'UniformOutput',0))
%     dpi = zeros(numel(handles.admin.all_trees),1,'uint16');
%     dpi(~cellfun(@(x) isempty(x.dpi),handles.admin.all_trees)) = 1;
%     dpi(dpi>0) = cat(1,handles.admin.all_trees{dpi>0}.dpi);
%     handles.admin.select = cat(2,handles.admin.select,dpi >= handles.admin.dpi_min & dpi <= handles.admin.dpi_max);
%
%     %% HFS check
%     %     HFS = cellfun(@(x) x.HFS,handles.admin.all_trees);%,'UniformOutput',0))
%     HFS = zeros(numel(handles.admin.all_trees),1,'uint16');
%     HFS(~cellfun(@(x) isempty(x.HFS),handles.admin.all_trees)) = 1;
%     HFS(HFS>0) = cat(1,handles.admin.all_trees{HFS>0});
%     switch sum([handles.admin.HFS_pos,handles.admin.HFS_neg])
%         case 0
%
%         case 1
%             if handles.admin.arc_pos
%                 handles.admin.select = cat(2,handles.admin.select,HFS == 1);
%             else
%                 handles.admin.select = cat(2,handles.admin.select,HFS == 0);
%             end
%         case 2
%             handles.admin.select = cat(2,handles.admin.select,~isempty(HFS));
%     end
%
%     %% Lateral Side Check
%     lateral_side = cellfun(@(x) x.lateral_side,handles.admin.all_trees,'UniformOutput',0);
%     switch sum([handles.admin.ipsi,handles.admin.contra])
%         case 0
%
%         case 1
%             if handles.admin.ipsi
%                 handles.admin.select = cat(2,handles.admin.select,strcmp({'ipsi'},lateral_side));%,'Ipsi','Ipsilateral','ipsilateral'},lateral_side));
%             else
%                 handles.admin.select = cat(2,handles.admin.select,strcmp({'contra'},lateral_side));%,'Contra','Contralateral','contralateral'},lateral_side));
%             end
%         case 2
%             handles.admin.select = cat(2,handles.admin.select,~strcmp('',lateral_side));
%     end
%
%     %% pyramidal blade check
%     pyramidal_blade = cellfun(@(x) x.pyramidal_blade,handles.admin.all_trees,'UniformOutput',0);
%     switch sum([handles.admin.ipsi,handles.admin.contra])
%         case 0
%
%         case 1
%             if handles.admin.supra
%                 handles.admin.select = cat(2,handles.admin.select,strcmp({'supra'},pyramidal_blade));%,'Supra','Suprapyramidal','suprapyramidal'},pyramidal_blade));
%             else
%                 handles.admin.select = cat(2,handles.admin.select,strcmp({'infra'},pyramidal_blade));%,'Infra','Infrapyramidal','infrapyramidal'},pyramidal_blade));
%             end
%         case 2
%             handles.admin.select = cat(2,handles.admin.select,~strcmp('',pyramidal_blade));
%     end
%
%
%
%     %% Arc check
%
%     arc = cellfun(@(x) x.arc,handles.admin.all_trees);%,'UniformOutput',0))
%     arc = zeros(numel(handles.admin.all_trees),1,'uint16');
%     arc(~cellfun(@(x) isempty(x.arc),handles.admin.all_trees)) = 1;
%     arc(arc>0) = cat(1,handles.admin.all_trees{arc>0});
%     switch sum([handles.admin.arc_pos,handles.admin.arc_neg])
%         case 0
%
%         case 1
%             if handles.admin.arc_pos
%                 handles.admin.select = cat(2,handles.admin.select,arc == 1);
%             else
%                 handles.admin.select = cat(2,handles.admin.select,arc == 0);
%             end
%         case 2
%             handles.admin.select = cat(2,handles.admin.select,~isempty(arc));
%     end
%
%     %% completeness check
%     completeness = cellfun(@(x) x.completeness,handles.admin.all_trees);%,'UniformOutput',0))
%     handles.admin.select = cat(2,handles.admin.select,completeness >= handles.admin.compl_min & completeness <= handles.admin.compl_max);
%
%
% end
%%
if sum(handles.admin.filter) == 0
    set(handles.Animal,'Value',1)
    set(handles.Animal,'String',{})
    handles.admin.selected_animals = [];
    set(handles.Trees,'String',{})
    handles.admin.filtered_trees = handles.admin.filter;
    set(handles.Details,'Data',{})
    set(handles.Details,'Enable','off')
    set(handles.n_sel_trees,'String','')
elseif ~handles.admin.locktreelist_ok
    if isfield(handles.filter,'filtered_animals')
        selanim = handles.filter.filtered_animals(handles.filter.selected_animals);
    else
        selanim = {};
    end
    handles.filter.filtered_animals = unique(cellfun(@(x) num2str(x.animal),handles.admin.all_trees(handles.admin.filter),'UniformOutput',0));
    liststring = handles.filter.filtered_animals;
    if any(cellfun(@isempty,liststring))
        liststring{cellfun(@isempty,liststring)} = 'Unknown';
    end
    set(handles.Animal,'String',liststring)
    selanimind = [];
    for a = 1:numel(selanim)
       ind = cellfun(@(x) strcmp(x,selanim{a}),handles.filter.filtered_animals); 
       if sum(ind)==1
          selanimind = cat(1,selanimind,find(ind)); 
       end
    end
    if ~isempty(selanimind)
        handles.filter.selected_animals = selanimind;
        set(handles.Animal,'Value',selanimind)
    elseif isempty(handles.filter.selected_animals) || ~all(get(handles.Animal,'Value')' == handles.filter.selected_animals) || any(handles.filter.selected_animals > numel(handles.filter.filtered_animals))
        set(handles.Animal,'Value',1)
        handles.filter.selected_animals = 1;
    end
    
    handles.filter.filtered_trees = handles.admin.filter & cellfun(@(x) any(strcmp(x.animal,handles.filter.filtered_animals(handles.filter.selected_animals))),handles.admin.all_trees)';%,'UniformOutput',0);
    handles.filter.filtered_tree_names = cell(sum(handles.filter.filtered_trees),2);
    filtered_trees = find(handles.filter.filtered_trees);
    for t = 1:numel(filtered_trees)
        t2 = filtered_trees(t);
        handles.filter.filtered_tree_names{t,1} = handles.admin.all_trees{t2}.name;
        handles.filter.filtered_tree_names{t,2} = t2;
    end
    set(handles.Trees,'String',handles.filter.filtered_tree_names(:,1))
end
if ~handles.admin.locktreelist_ok && (~exist('liststring','var') || numel(get(handles.Animal,'String')) ~= numel(liststring) || ~all(strcmp(get(handles.Animal,'String'),liststring')) || any(size(handles.filter.filtered_tree_names,1) < handles.filter.selected_trees))
    handles.filter.selected_trees = 1;
    set(handles.Trees,'Value',1)
    set(handles.n_sel_trees,'String','1 tree(s) selected')
end
if sum(handles.admin.filter) ~= 0
    selected_tree_names = handles.filter.filtered_tree_names(handles.filter.selected_trees,1);
    if numel(get(handles.Details,'RowName')) ~= numel(selected_tree_names) || ~all(strcmp(selected_tree_names,get(handles.Details,'RowName')))
        handles.admin.selected_detail = [];
    end
    set(handles.Details,'Enable','on')
    set(handles.Details,'RowName',selected_tree_names)
    %     selected_trees = cat(1,handles.admin.all_trees{cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2})}); %struct
    selected_trees = handles.admin.all_trees(cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2}));
    
    details_cell = cell(numel(selected_trees),numel(handles.admin.tags(1,:)));
    for c = 1:size(details_cell,2)
        
        %    details_cell(1:numel(selected_trees),c)={selected_trees.(handles.admin.tags{1,c})}'; %struct
        details_cell(1:numel(selected_trees),c)=cellfun(@(x) x.(handles.admin.tags{1,c}),selected_trees,'UniformOutput',0)';
    end
    set(handles.Details,'Data',details_cell)%,'ColumnFormat',{'char','short','logical',{'ipsi','contra','unknown'},{'supra','infra','unknown'},'logical','short','short','short'})
end

%% Tree Preview
set(handles.TreeAdmin,'CurrentAxes',handles.Preview)
cla(handles.Preview)
if handles.admin.preview_ok && exist('selected_trees','var')
    [DD,spreaded_trees] = spread_tree(selected_trees);
    for t = 1:numel(selected_trees)
        plot_tree(spreaded_trees{t},handles.admin.treecolors(t,:));%, color, DD, ipart, res, options)
    end
end

%% Finish
if get(handles.Legend_ok,'Value')
    legend(handles.Preview,handles.filter.filtered_tree_names(handles.filter.selected_trees,1))
end
guidata(handles.TreeAdmin,handles)