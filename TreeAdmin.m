function varargout = TreeAdmin(varargin)
% TREEADMIN M-file for TreeAdmin.fig
%      TREEADMIN, by itself, creates a new TREEADMIN or raises the existing
%      singleton*.
%
%      H = TREEADMIN returns the handle to a new TREEADMIN or the handle to
%      the existing singleton*.
%
%      TREEADMIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREEADMIN.M with the given input arguments.
%
%      TREEADMIN('Property','Value',...) creates a new TREEADMIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TreeAdmin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TreeAdmin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TreeAdmin

% Last Modified by GUIDE v2.5 12-Feb-2013 14:22:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TreeAdmin_OpeningFcn, ...
                   'gui_OutputFcn',  @TreeAdmin_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TreeAdmin is made visible.
function TreeAdmin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TreeAdmin (see VARARGIN)

% Choose default command line output for TreeAdmin
handles.output = hObject;
handles.admin.curr_dir = pwd;

handles.admin.key_pressed = false;
handles.TreeAdmin = hObject;
handles.admin.tags = {'animal','region','cell_type','dpi','HFS','lateral_side','pyramidal_blade','arc','completeness','x_scale','y_scale','z_scale','tracing_unsure','done'};
handles.admin.tags(2,:) = cellfun(@str2func,{'num2str','num2str','num2str','uint16','num2str','num2str','num2str','num2str','uint8','single','single','single','num2str','num2str'},'UniformOutput', false);
% handles.admin.tags(3,:) = {false,false,false,true,true,true,true,true,true,false,false,false,true,true};
% handles.admin.tags(4,:) = {{'Name'},{'Name'},{'Name'},{'from','to'},{'yes','no'},{'ipsi','contra'},{'supra','infra','crest'},{'positive','negative'},{'from','to'},{'from','to'},{'from','to'},{'from','to'},{'yes','no'},{'yes','no'}};
% handles.admin.tags(5,:) = {{''},{''},{''},{0,300},{false,false},{false,false},{false,false,false},{false,false},{0,100},{0,5},{0,5},{0,5},{false,false},{false,false}};
set(handles.Details,'ColumnFormat',{'char','char','char','short',{'unknown','yes','no'},{'unknown','ipsi','contra'},{'unknown','supra','infra','crest'},{'unknown','positive','negative'},'short','short','short','short',{'unknown','yes','no'},{'unknown','yes','no'}})
handles.filter.dpi_ok = false;
handles.filter.dpi_min = 0;
handles.filter.dpi_max = 300;
handles.filter.completeness_ok = false;
handles.filter.completeness_min = 0;
handles.filter.completeness_max = 100;
handles.filter.done_yes = 0;
handles.filter.done_no = 0;
handles.filter.HFS_pos = 0;
handles.filter.HFS_neg = 0;
handles.filter.ipsi = 0;
handles.filter.contra = 0;
handles.filter.supra = 0;
handles.filter.infra = 0;
handles.filter.arc_pos = 0;
handles.filter.arc_neg = 0;

% handles.admin.tags = handles.admin.tags(:,cell2mat(handles.admin.tags(3,:)));
% FilterTags = cell(max(cellfun(@(x) numel(x),handles.admin.tags(4,:)))+1,size(handles.admin.tags,2)*2);
% for f = 1:size(handles.admin.tags,2)
%    FilterTags(1:numel(handles.admin.tags{4,f})+1,2*f-1) =  [handles.admin.tags(1,f) handles.admin.tags{4,f}]';
%     FilterTags(1:numel(handles.admin.tags{4,f})+1,2*f) = [false, handles.admin.tags{5,f}]';
% end
handles.filter.changed = false;
handles.filter.selected_animals = 1;
handles.filter.selected_trees = 1;

set(handles.Details,'ColumnName',handles.admin.tags(1,:))

set(handles.Details,'ColumnEditable',true(1,numel(handles.admin.tags(1,:))))
set(handles.Details,'Data',{})
set(handles.Details,'Enable','off')
handles.admin.selected_detail = [];

handles.admin.stat_trees = cell(0,2);

handles.admin.locktreelist_ok = false;
handles.admin.preview_ok = true;
b=axes('position',[20 20 100 100],'visible','off');
handles.admin.treecolors = colormap(b,'lines');
delete(b)
set(handles.TreeAdmin,'Position',[1,1,1200,650]);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TreeAdmin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TreeAdmin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Animal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Dpi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dpi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function dpi_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpi_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function dpi_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpi_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Completeness_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Completeness_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Completeness_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Completeness_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Details_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Details (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Trees_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Stat_Trees_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function uipushopen_ClickedCallback(hObject, eventdata, handles,mode)
% hObject    handle to uipushopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch mode
    case 1
        handles.admin.all_tree_file_names = [];
        [all_tree_file_names, handles.admin.curr_dir ] = uigetfile({'*.mtr','.mtr files (Treestoolbox)'},'Choose the tree file(s) you want to open',handles.admin.curr_dir,'MultiSelect','on');
        if ~iscell(all_tree_file_names) && ~ischar(all_tree_file_names)
            return
        end
        if iscell(all_tree_file_names)
            for f = 1:numel(all_tree_file_names)
                handles.admin.all_tree_file_names(f).name = all_tree_file_names{f};
            end
        else
            handles.admin.all_tree_file_names.name = all_tree_file_names;
        end
    case 2
        handles.admin.curr_dir = uigetdir(handles.admin.curr_dir,'Choose the directory which comprises the tree files');
        if ~ischar(handles.admin.curr_dir)
            return
        end
        handles.admin.all_tree_file_names = dir(sprintf('%s/*.mtr',handles.admin.curr_dir));
        for f = 1:numel(handles.admin.all_tree_file_names)
            handles.admin.all_tree_file_names(f).changed = false;
        end
end

% if numel(handles.admin.all_tree_file_names) == 0

handles.admin.all_trees = cell(0);
wrong_file = 0;
% names = cell(0);
for f = 1:numel(handles.admin.all_tree_file_names)
    curr_file = load_tree(fullfile(handles.admin.curr_dir,handles.admin.all_tree_file_names(f).name));
    if iscell(curr_file) && iscell(curr_file{1})
        if numel(curr_file) == 1
            curr_file = curr_file{1};
        else
            wrong_file = wrong_file +1;
            continue
        end
    end
    handles.admin.all_tree_file_names(f).treeref = (1:numel(curr_file))+numel(handles.admin.all_trees);
    for tree = 1:numel(curr_file)
        for tag = 1:numel(handles.admin.tags(1,:))
           if ~isfield(curr_file{tree},handles.admin.tags{1,tag})
              curr_file{tree}.(handles.admin.tags{1,tag}) = handles.admin.tags{2,tag}([]); 
           end
        end
%         names = unique(cat(1,names,fieldnames(curr_file{tree})));
    end
    %     curr_file = curr_file(cellfun(@(x)  numel(x.X),curr_file)>10);  % sort out uncompleted trees
    handles.admin.all_trees(end+1:end+numel(curr_file)) = curr_file;
end

if wrong_file > 0
   warndlg(sprintf('Warning: %d files could not be loaded because a file must only one tree group!',wrong_file),'Unsupported Files')
end
handles.admin.stat_trees = cell(0,2);
TreeAdmin_UpdateStats(handles);

handles.admin.deleted_trees = false(numel(handles.admin.all_trees),1);
set(handles.Animal,'Value',1)
set(handles.Trees,'Value',1)
set(handles.n_sel_trees,'String','1 tree(s) selected')
handles.admin.locktreelist_ok = false;
set(handles.Lock_ok,'Value',0)
set(handles.Lock_ok,'ForegroundColor',[0 0 0])
set(handles.Animal,'Enable','on')
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --------------------------------------------------------------------
function uipushsave_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
w = waitbar(0,'Saving Trees');
for f = 1:numel(handles.admin.all_tree_file_names)
    treeref = handles.admin.all_tree_file_names(f).treeref;
    waitbar(f/numel(handles.admin.all_tree_file_names),w)
    if any(handles.admin.deleted_trees(treeref))
       answer = questdlg(sprintf('Trees of file "%s" have been deleted.\n Overwrite file nonetheless?',handles.admin.all_tree_file_names(f).name),'Overwrite Warning','No');
       if any(strcmp(answer,{'','Cancel'}))
           break
       elseif strcmp(answer,'No')
           continue
       end
    end
    treeref(handles.admin.deleted_trees(treeref))=[];
    curr_file = {handles.admin.all_trees(treeref)};
    if numel(curr_file{1}) == 1
       curr_file = curr_file{1}; 
    end
    save_tree(curr_file,fullfile(handles.admin.curr_dir,handles.admin.all_tree_file_names(f).name));
end
close(w)

% --------------------------------------------------------------------
function uipushsavenew_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushsavenew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[curr_filename,curr_dir] = uiputfile({'*.mtr','.mtr files (Treestoolbox)'},'In order to save the selected trees, please choose a directory and a file name.','NewTreeFile');
w = waitbar(0,'Saving Trees');
curr_file = {handles.admin.all_trees(cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2}))};
if numel(curr_file{1}) == 1
    curr_file = curr_file{1};
end
waitbar(0.9,w)
save_tree(curr_file,fullfile(curr_dir,curr_filename));
close(w)

% --- Executes on button press in dpi_ok.
function dpi_ok_Callback(hObject, eventdata, handles)
% hObject    handle to dpi_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.dpi_ok = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);




function dpi_min_Callback(hObject, eventdata, handles)
% hObject    handle to dpi_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject,'String'));
if isnan(value) || value > handles.filter.dpi_max
   value = 0; 
   set(hObject,'String',value)
end
handles.filter.dpi_min = value;
if handles.filter.dpi_ok
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);


function dpi_max_Callback(hObject, eventdata, handles)
% hObject    handle to dpi_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(hObject,'String'));
if isnan(value) || value < handles.filter.dpi_min
   value = 300; 
   set(hObject,'String',value)
end
handles.filter.dpi_max = value;
if handles.filter.dpi_ok
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in Arcplus.
function Arcplus_Callback(hObject, eventdata, handles)
% hObject    handle to Arcplus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.arc_pos = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in Arcnegative.
function Arcnegative_Callback(hObject, eventdata, handles)
% hObject    handle to Arcnegative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.arc_neg = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in HFSpositive.
function HFSpositive_Callback(hObject, eventdata, handles)
% hObject    handle to HFSpositive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.HFS_pos = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in HFSnegative.
function HFSnegative_Callback(hObject, eventdata, handles)
% hObject    handle to HFSnegative (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.HFS_neg = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in Infra.
function Infra_Callback(hObject, eventdata, handles)
% hObject    handle to Infra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.infra = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in Supra.
function Supra_Callback(hObject, eventdata, handles)
% hObject    handle to Supra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.supra = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in completeness_ok.
function completeness_ok_Callback(hObject, eventdata, handles)
% hObject    handle to completeness_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.completeness_ok = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

function Completeness_min_Callback(hObject, eventdata, handles)
% hObject    handle to Completeness_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject,'String'));
if isnan(value) || value < 0 || value > handles.filter.completeness_max
   value = 0; 
   set(hObject,'String',value)
end
handles.filter.completeness_min = value;
if handles.filter.completeness_ok
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);

function Completeness_max_Callback(hObject, eventdata, handles)
% hObject    handle to Completeness_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(hObject,'String'));
if isnan(value) || value < handles.filter.completeness_min || value > 100
   value = 100; 
   set(hObject,'String',value)
end
handles.filter.completeness_max = value;
if handles.filter.completeness_ok
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in Ipsi.
function Ipsi_Callback(hObject, eventdata, handles)
% hObject    handle to Ipsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.ipsi = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in Contra.
function Contra_Callback(hObject, eventdata, handles)
% hObject    handle to Contra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.contra = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);



% --- Executes on selection change in Animal.
function Animal_Callback(hObject, eventdata, handles)
% hObject    handle to Animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.admin.key_pressed
    if handles.filter.selected_animals ~= get(hObject,'Value')
        handles.filter.selected_trees = 1;
        set(handles.Trees,'Value',1)
        set(handles.n_sel_trees,'String','1 tree(s) selected')
    end
    handles.filter.selected_animals = get(hObject,'Value');
    TreeAdmin_UpdateGUI(handles);
end


% --- Executes on selection change in Trees.
function Trees_Callback(hObject, eventdata, handles)
% hObject    handle to Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.admin.key_pressed
    handles.filter.selected_trees = get(hObject,'Value');
    set(handles.n_sel_trees,'String',sprintf('%d tree(s) selected',numel(handles.filter.selected_trees)))
    TreeAdmin_UpdateGUI(handles);
end



% --- Executes when entered data in editable cell(s) in Details.
function Details_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Details (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
data = get(handles.Details,'Data');
% if isnan(eventdata.NewData)
%     
%     data{eventdata.Indices(1),eventdata.Indices(2)} = eventdata.EditData;
%     set(handles.Details,'Data',data)
% end
tree = handles.filter.selected_trees(eventdata.Indices(1));
tag = eventdata.Indices(2);
this_entry = data{eventdata.Indices(1),eventdata.Indices(2)};
if isempty(this_entry)
    this_entry = [];
end
handles.admin.all_trees{handles.filter.filtered_tree_names{tree,2}}.(handles.admin.tags{1,tag}) = handles.admin.tags{2,eventdata.Indices(2)}(this_entry);
if ~TreeAdmin_checktreewithfilter(handles.admin.all_trees{handles.filter.filtered_tree_names{tree,2}},handles.filter)
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA
if strcmp(eventdata.Key,{'uparrow','downarrow'})
    handles.admin.key_pressed = true;
    guidata(handles.TreeAdmin,handles)
end

% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
if strcmp(eventdata.Key,{'uparrow','downarrow'})
    handles.admin.key_pressed = false;
    handles.filter.selected_trees = get(handles.Trees,'Value');
    Animal_Callback(handles.Animal, [], handles)
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Animal.
function Animal_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject,'Enable'),'on') && ~isempty(get(hObject,'String'))
    old_name = handles.filter.filtered_animals(handles.filter.selected_animals);
%     old_name{cellfun(@(x) strcmp(x,'Unknown'),old_name)} = '';
    new_name = inputdlg(repmat({'New Name:'},[numel(handles.filter.selected_animals) 1]),'Rename animal',1,old_name)';
    if isempty(new_name)
        return
    end
    new_name = new_name(~cellfun(@strcmp,old_name,new_name)); % leaves out unchanged names
    for n = 1:numel(new_name)
        rename_these = find(cellfun(@(x) strcmp(x.animal,old_name(n)),handles.admin.all_trees));
        if isempty(new_name{n})
            handles.admin.deleted_trees(rename_these) = true;
        else
            for t = 1:numel(rename_these)
                handles.admin.all_trees{rename_these(t)}.animal = new_name{n};
            end
        end
    end
    handles.filter.changed = 1;
    handles.filter.selected_trees = 1;
    set(handles.Trees,'Value',1)
    set(handles.n_sel_trees,'String','1 tree(s) selected')
    set(handles.Animal,'Value',1)
    TreeAdmin_UpdateGUI(handles);
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Trees.
function Trees_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(get(handles.Trees,'String'))
    new_name = inputdlg(repmat({'New Name:'},[numel(handles.filter.selected_trees) 1]),'Rename tree',1,handles.filter.filtered_tree_names(handles.filter.selected_trees,1));
    delete_this_ID = [];
    for t = 1:numel(new_name)
        if isempty(new_name{t})
            delete_this_ID(end+1) = handles.filter.filtered_tree_names{handles.filter.selected_trees(t),2};
%             delete_treeref = find(cellfun(@(x) any(x == delete_this_ID(end)),{handles.admin.all_tree_file_names.treeref}));
%             handles.admin.all_tree_file_names(delete_treeref).treeref = setdiff(handles.admin.all_tree_file_names(delete_treeref).treeref,delete_this_ID(end));
%             handles.admin.all_tree_file_names(delete_treeref).changed = true;
        else
            handles.admin.all_trees{handles.filter.filtered_tree_names{handles.filter.selected_trees(t),2}}.name = new_name{t};
        end
    end
    if ~isempty(delete_this_ID)
       handles.admin.deleted_trees(delete_this_ID) = true;
       handles.filter.changed = 1;
    end
    TreeAdmin_UpdateGUI(handles);
end


% --- Executes on button press in Legend_ok.
function Legend_ok_Callback(hObject, eventdata, handles)
% hObject    handle to Legend_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    legend(handles.Preview,handles.filter.filtered_tree_names(handles.filter.selected_trees,1))
else
    legend(handles.Preview,'off')
end


% --- Executes on button press in Preview_ok.
function Preview_ok_Callback(hObject, eventdata, handles)
% hObject    handle to Preview_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.admin.preview_ok = true;
else
    handles.admin.preview_ok = false;
end
TreeAdmin_UpdateGUI(handles);


% --------------------------------------------------------------------
function Details_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Details (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if numel(handles.admin.selected_detail) == 2 && numel(handles.filter.selected_trees) > 1
    data = get(handles.Details,'Data');
    this_entry = data{handles.admin.selected_detail(1),handles.admin.selected_detail(2)};
    tag = handles.admin.tags{1,handles.admin.selected_detail(2)};
    if strcmp(num2str(this_entry),'')
        answer = 'No';
        this_entry = inputdlg('Put in the value you want to apply to all selected trees','Multi-Entry');
        if ~isempty(this_entry)
            this_entry = this_entry{1};
            ColumnFormat = get(handles.Details,'ColumnFormat');
            
            if iscell(ColumnFormat{handles.admin.selected_detail(2)})
                if strcmp(handles.admin.tags{2,handles.admin.selected_detail(2)}(this_entry),ColumnFormat{handles.admin.selected_detail(2)})
                    answer = 'Yes';
                end
            else
                if strcmp(ColumnFormat{handles.admin.selected_detail(2)},'short')
                    if ~isnan(str2double(this_entry))
                        this_entry = str2double(this_entry);
                        answer = 'Yes';
                    elseif strcmp(this_entry,'')
                        this_entry = [];
                        answer = 'Yes';
                    end
                else
                    answer = 'Yes';
                end
            end
        end
    else
        answer = questdlg(sprintf('Do you really want to copy the entry %s of tag %s to all other selected trees?',num2str(this_entry),tag),'Overwrite all entries');
    end
    if strcmp(answer,'Yes')
        trees2overwrite = cell2mat(handles.filter.filtered_tree_names(handles.filter.selected_trees,2));
        for t = 1:numel(trees2overwrite)
            handles.admin.all_trees{trees2overwrite(t)}.(tag) = this_entry;
            
            if ~handles.filter.changed && ~TreeAdmin_checktreewithfilter(handles.admin.all_trees{trees2overwrite(t)},handles.filter)
                handles.filter.changed = true;
            end
        end
        TreeAdmin_UpdateGUI(handles);
    end
end


% --- Executes when selected cell(s) is changed in Details.
function Details_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to Details (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.admin.selected_detail = eventdata.Indices;
guidata(handles.TreeAdmin,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in Lock_ok.
function Lock_ok_Callback(hObject, eventdata, handles)
% hObject    handle to Lock_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.admin.locktreelist_ok = get(hObject,'Value');
set(hObject,'ForegroundColor',[handles.admin.locktreelist_ok 0 0])
s = {'on','off'};
set(handles.Animal,'Enable',s{handles.admin.locktreelist_ok+1})
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in done_no.
function done_no_Callback(hObject, eventdata, handles)
% hObject    handle to done_no (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filter.done_no = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in done_yes.
function done_yes_Callback(hObject, eventdata, handles)
% hObject    handle to done_yes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filter.done_yes = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on selection change in Stat_Trees.
function Stat_Trees_Callback(hObject, eventdata, handles)
% hObject    handle to Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Stat_Trees contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Stat_Trees


% --- Executes on button press in Start_Stats.
function Start_Stats_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TreeAdmin_Statistics(handles.admin.stat_trees(:,1), handles.admin.stat_trees(:,2))



% --- Executes on button press in Add_Stat_Trees.
function Add_Stat_Trees_Callback(hObject, eventdata, handles)
% hObject    handle to Add_Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
answer = inputdlg('Please give name for selected tree group','Adding Tree Group for Statistics');
if ~isempty(answer)
    handles.admin.stat_trees{end+1,1} = handles.admin.all_trees(cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2}));
    handles.admin.stat_trees{end,2} = answer{1};
end
TreeAdmin_UpdateStats(handles);
guidata(handles.TreeAdmin,handles);

% --- Executes on button press in Del_Stat_Trees.
function Del_Stat_Trees_Callback(hObject, eventdata, handles)
% hObject    handle to Del_Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_this_group = get(handles.Stat_Trees,'Value');
handles.admin.stat_trees(del_this_group,:) = [];
TreeAdmin_UpdateStats(handles);
guidata(handles.TreeAdmin,handles);


% --------------------------------------------------------------------
function Rescale_Trees_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Rescale_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_scale = inputdlg('Please enter new scale','Rescale Trees',1,{'[0.4112,0.4112,1.5]'});
new_scale = str2num(new_scale{1});
if numel(new_scale)~=3 || isempty(new_scale)
    return
end
for i = 1: numel(handles.filter.selected_trees)
    tree = handles.admin.all_trees{handles.filter.filtered_tree_names{handles.filter.selected_trees(i),2}};
    fac = [new_scale(1)/tree.x_scale, new_scale(2)/tree.y_scale, new_scale(3)/tree.z_scale];
    tree.x_scale = new_scale(1);
    tree.y_scale = new_scale(2);
    tree.z_scale = new_scale(3);
    if fac(1) == fac(2)
       tree = scale_tree(tree,fac(1)); 
       fac = fac/fac(1);
    end
    handles.admin.all_trees{handles.filter.filtered_tree_names{handles.filter.selected_trees(i),2}} = resample_tree(scale_tree (tree, fac),1);
end
guidata(handles.TreeAdmin,handles);
TreeAdmin_UpdateGUI(handles);

