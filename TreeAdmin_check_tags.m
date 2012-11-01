function [no_tags missing_tags] =  TreeAdmin_check_tags(handles)

missing_tags = ~cellfun(@all,cellfun(@(X) isfield(X,handles.admin.tags),handles.admin.all_trees,'UniformOutput',0));
no_tags = ~cellfun(@any,cellfun(@(X) isfield(X,handles.admin.tags),handles.admin.all_trees,'UniformOutput',0));


if any(missing_tags)
    set(handles.showmarginaltaggedtrees,'Enable','On')
else
    set(handles.showmarginaltaggedtrees,'Enable','Off')
end

if any(no_tags)
    set(handles.showuntaggedtrees,'Enable','On')
else
    set(handles.showuntaggedtrees,'Enable','Off')
end
    