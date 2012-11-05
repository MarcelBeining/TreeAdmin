function TreeAdmin_UpdateStats(handles)

if isempty(handles.admin.stat_trees)
    set(handles.Stat_Trees,'String',{''})
    set(handles.Stat_Trees,'Value',1)
    set(handles.Stat_Trees,'Enable','off')
    set(handles.Del_Stat_Trees,'Enable','off')
    set(handles.Start_Stats,'Enable','off')
else
    set(handles.Stat_Trees,'Enable','on')
    set(handles.Del_Stat_Trees,'Enable','on')
    set(handles.Start_Stats,'Enable','on')
    set(handles.Stat_Trees,'String',handles.admin.stat_trees(:,2))
    set(handles.Stat_Trees,'Value',size(handles.admin.stat_trees,1))
end