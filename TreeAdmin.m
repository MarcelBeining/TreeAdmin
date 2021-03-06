function varargout = TreeAdmin(varargin)
% TREEADMIN M-file for TreeAdmin.fig
%      TREEADMIN, by itself, creates a new TREEADMIN or raises the existing
%      singleton*.
%
%      H = TREEADMIN returns the handle to a new TREEADMIN or the handle to
%      the existing singleton*.
%
%      TREEADMIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREEADMIN.M with the given input
%      arguments.
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

% Last Modified by GUIDE v2.5 25-Apr-2016 10:52:16

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
function TreeAdmin_OpeningFcn(hObject, ~, handles, varargin)
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
set(handles.Details,'ColumnFormat',{'char','char','char','short',{'unknown','yes','no'},{'unknown','ipsi','contra'},{'unknown','supra','infra','crest'},{'unknown','positive','negative'},'short','short','short','short',{'unknown','yes','no'},{'unknown','yes','no'}})
handles.filter.check_dpi = false;
handles.filter.dpi_min = 0;
handles.filter.dpi_max = 300;
handles.filter.check_completeness = false;
handles.filter.completeness_min = 0;
handles.filter.completeness_max = 100;
handles.filter.check_done = 0;
handles.filter.check_notdone = 0;
handles.filter.check_HFS_pos = 0;
handles.filter.check_HFS_neg = 0;
handles.filter.check_ipsi = 0;
handles.filter.check_contra = 0;
handles.filter.check_supra = 0;
handles.filter.check_infra = 0;
handles.filter.check_arc_pos = 0;
handles.filter.check_arc_neg = 0;

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
handles.admin.rotate_ok = true;
b=axes('position',[20 20 100 100],'visible','off');
handles.admin.treecolors = colorme({'blue','light blue','green','orange','dim red','dark red','pink','violett','black'});
handles.admin.treecolors = cat(1,handles.admin.treecolors{:});
delete(b)
set(handles.TreeAdmin,'Position',[1,1,1200,650]);
handles.varargin = false;
if ~isempty(varargin)
    if iscell(varargin{1}) && isstruct(varargin{1}{1})
        handles.admin.all_trees = varargin{1};
    elseif isstruct(varargin{1})
        handles.admin.all_trees = varargin(1);
    end
    if isfield(handles.admin,'all_trees')
        set(handles.uipushopen,'Enable','off')
        set(handles.uipushopensingle,'Enable','off')
        set(handles.uipushsave,'Enable','off')
        set(handles.uipushsavenew,'Enable','off')
        handles.filter.changed = 1;
        handles.admin.deleted_trees = false(numel(handles.admin.all_trees),1);
        handles.varargin = true;
        for tree = 1:numel(handles.admin.all_trees)
            for tag = 1:numel(handles.admin.tags(1,:))
                if ~isfield(handles.admin.all_trees{tree},handles.admin.tags{1,tag})
                    handles.admin.all_trees{tree}.(handles.admin.tags{1,tag}) = handles.admin.tags{2,tag}([]);
                end
            end
        end
    end
    
end
% Update handles structure
guidata(hObject, handles);
TreeAdmin_UpdateGUI(handles)
if ~isempty(varargin)
% UIWAIT makes TreeAdmin wait for user response (see UIRESUME)
    uiwait(handles.figure1);
end



% --- Outputs from this function are returned to the command line.
function varargout = TreeAdmin_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
if handles.varargin && isfield(handles.admin,'all_trees')
    varargout{1} = {handles.admin.all_trees};
    delete(handles.figure1);
end


% --- Executes during object creation, after setting all properties.
function Animal_CreateFcn(hObject, ~, ~)
% hObject    handle to Animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(~, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% --- Executes during object creation, after setting all properties.
function Details_CreateFcn(~, ~, ~)
% hObject    handle to Details (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


% --- Executes during object creation, after setting all properties.
function Dpi_CreateFcn(hObject, ~, ~)
% hObject    handle to Dpi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function dpi_min_CreateFcn(hObject, ~, ~)
% hObject    handle to dpi_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function dpi_max_CreateFcn(hObject, ~, ~)
% hObject    handle to dpi_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Completeness_min_CreateFcn(hObject, ~, ~)
% hObject    handle to Completeness_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Completeness_max_CreateFcn(hObject, ~, ~)
% hObject    handle to Completeness_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Trees_CreateFcn(hObject, ~, ~)
% hObject    handle to Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Stat_Trees_CreateFcn(hObject, ~, ~)
% hObject    handle to Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------------------------------
function uipushopen_ClickedCallback(~, ~, handles,mode)
% hObject    handle to uipushopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles.admin,'all_tree_file_names') && ~isempty(handles.admin.all_tree_file_names)
    answer = questdlg('Add files to current catalog or forget current catalog and make a new one?','Concatenate?','Add','New','Add');
    
    if strcmp(answer,'Add')
        startind = numel(handles.admin.all_tree_file_names)+1;
    elseif strcmp(answer,'New')
        startind = 1;
        handles.admin.all_trees = cell(0);
        handles.admin.all_tree_file_names = [];
        handles.admin.stat_trees = cell(0,2);
    else
        return
    end
else
    handles.admin.all_tree_file_names = [];
    handles.admin.all_trees = cell(0);
    startind = 1;
end

switch mode
    case 1
        %handles.admin.all_tree_file_names = [];
        [all_tree_file_names, handles.admin.curr_dir ] = uigetfile({'*.mtr;*.swc;*.neu','Reconstruction Files (*.mtr,*.swc,*.neu)';
            '*.mtr',  'Treestoolbox files (*.mtr)'; ...
            '*.swc','Neurolucida files (*.swc)'; ...
            '*.neu','NEURON files (*.neu)'},'Choose the tree file(s) you want to open',handles.admin.curr_dir,'MultiSelect','on');
        if ~iscell(all_tree_file_names) && ~ischar(all_tree_file_names)
            return
        end
        if iscell(all_tree_file_names)
            for f = 1:numel(all_tree_file_names)
                handles.admin.all_tree_file_names(startind+f-1).name = fullfile(handles.admin.curr_dir,all_tree_file_names{f});
            end
        else
            handles.admin.all_tree_file_names(startind).name = fullfile(handles.admin.curr_dir,all_tree_file_names);
        end
    case 2
        handles.admin.curr_dir = uigetdir(handles.admin.curr_dir,'Choose the directory which comprises the tree files');
        if ~ischar(handles.admin.curr_dir)
            return
        end

        all_tree_file_names = dir(sprintf('%s/*',handles.admin.curr_dir));
        for f = 1:numel(all_tree_file_names)
            all_tree_file_names(f).name = fullfile(handles.admin.curr_dir,all_tree_file_names(f).name);
            all_tree_file_names(f).changed = false;
            all_tree_file_names(f).treeref = [];
        end
        handles.admin.all_tree_file_names = cat(1,handles.admin.all_tree_file_names,all_tree_file_names(~cellfun(@isempty,regexpi({all_tree_file_names.name},'.mtr')) & cellfun(@isempty,regexpi({all_tree_file_names.name},'.asv'))));
        for f = startind:numel(handles.admin.all_tree_file_names)
            handles.admin.all_tree_file_names(f).changed = false;
        end
end

% if numel(handles.admin.all_tree_file_names) == 0
wrong_file = 0;
% names = cell(0);
for f = startind:numel(handles.admin.all_tree_file_names)
    curr_file = load_tree(fullfile(handles.admin.all_tree_file_names(f).name));
    if iscell(curr_file) && iscell(curr_file{1})
%         if numel(curr_file) == 1
%             curr_file = curr_file{1};
%         else
%             wrong_file = wrong_file +1;
%             continue
%         end
        curr_file = cat_groups(curr_file);
    elseif isstruct(curr_file)
        curr_file = {curr_file};
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
   warndlg(sprintf('Warning: %d files could not be loaded because a file must only have one tree group!',wrong_file),'Unsupported Files')
end

TreeAdmin_UpdateStats(handles);

handles.admin.deleted_trees = false(numel(handles.admin.all_trees),1);
set(handles.Animal,'Value',1)
set(handles.Trees,'Value',1)
set(handles.n_sel_trees,'String','1 tree(s) selected')
handles.admin.locktreelist_ok = false;
set(handles.Lock_ok,'Value',0)
set(handles.Lock_ok,'ForegroundColor',[0 0 0])
set(handles.Animal,'Enable','on')
handles = reset_filter(handles);
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --------------------------------------------------------------------
function uipushsave_ClickedCallback(~, ~, handles)
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
    save_tree(curr_file,fullfile(handles.admin.all_tree_file_names(f).name));
end
close(w)

% --------------------------------------------------------------------
function uipushsavenew_ClickedCallback(~, ~, handles)
% hObject    handle to uipushsavenew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[curr_filename,curr_dir] = uiputfile({'*.mtr','.mtr files (Treestoolbox)'},'In order to save the selected trees, please choose a directory and a file name.',sprintf('%sNewTreeFile.mtr',handles.admin.curr_dir));
if curr_dir == 0
    return
end
w = waitbar(0,'Saving Trees');
curr_file = {handles.admin.all_trees(cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2}))};
if numel(curr_file{1}) == 1
    curr_file = curr_file{1};
end
waitbar(0.9,w)
save_tree(curr_file,fullfile(curr_dir,curr_filename));
close(w)

% --- Executes on button press in check_dpi.
function check_dpi_Callback(hObject, ~, handles)
% hObject    handle to check_dpi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_dpi = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);




function dpi_min_Callback(hObject, ~, handles)
% hObject    handle to dpi_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject,'String'));
if isnan(value) || value > handles.filter.dpi_max
   value = 0; 
   set(hObject,'String',value)
end
handles.filter.dpi_min = value;
if handles.filter.check_dpi
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);


function dpi_max_Callback(hObject, ~, handles)
% hObject    handle to dpi_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(hObject,'String'));
if isnan(value) || value < handles.filter.dpi_min
   value = 300; 
   set(hObject,'String',value)
end
handles.filter.dpi_max = value;
if handles.filter.check_dpi
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in check_arc_pos.
function check_arc_pos_Callback(hObject, ~, handles)
% hObject    handle to check_arc_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_arc_pos = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in check_arc_neg.
function check_arc_neg_Callback(hObject, ~, handles)
% hObject    handle to check_arc_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_arc_neg = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in check_HFS_pos.
function check_HFS_pos_Callback(hObject, ~, handles)
% hObject    handle to check_HFS_pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_HFS_pos = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in check_HFS_neg.
function check_HFS_neg_Callback(hObject, ~, handles)
% hObject    handle to check_HFS_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_HFS_neg = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in check_infra.
function check_infra_Callback(hObject, ~, handles)
% hObject    handle to check_infra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_infra = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in check_supra.
function check_supra_Callback(hObject, ~, handles)
% hObject    handle to check_supra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_supra = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in check_completeness.
function check_completeness_Callback(hObject, ~, handles)
% hObject    handle to check_completeness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_completeness = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

function Completeness_min_Callback(hObject, ~, handles)
% hObject    handle to Completeness_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = str2double(get(hObject,'String'));
if isnan(value) || value < 0 || value > handles.filter.completeness_max
   value = 0; 
   set(hObject,'String',value)
end
handles.filter.completeness_min = value;
if handles.filter.check_completeness
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);

function Completeness_max_Callback(hObject, ~, handles)
% hObject    handle to Completeness_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = str2double(get(hObject,'String'));
if isnan(value) || value < handles.filter.completeness_min || value > 100
   value = 100; 
   set(hObject,'String',value)
end
handles.filter.completeness_max = value;
if handles.filter.check_completeness
    handles.filter.changed = 1;
end
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in check_ipsi.
function check_ipsi_Callback(hObject, ~, handles)
% hObject    handle to check_ipsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_ipsi = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in check_contra.
function check_contra_Callback(hObject, ~, handles)
% hObject    handle to check_contra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.filter.check_contra = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);



% --- Executes on selection change in Animal.
function Animal_Callback(hObject, ~, handles)
% hObject    handle to Animal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.admin.key_pressed
    if numel(handles.filter.selected_animals) ~= numel(get(hObject,'Value')) || any(handles.filter.selected_animals ~= get(hObject,'Value')')
        handles.filter.selected_trees = 1;
        set(handles.Trees,'Value',1)
        set(handles.n_sel_trees,'String','1 tree(s) selected')
    end
    handles.filter.selected_animals = get(hObject,'Value');
    TreeAdmin_UpdateGUI(handles);
end


% --- Executes on selection change in Trees.
function Trees_Callback(hObject, ~, handles)
% hObject    handle to Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.admin.key_pressed
    handles.filter.selected_trees = get(hObject,'Value');
    set(handles.n_sel_trees,'String',sprintf('%d tree(s) selected',numel(handles.filter.selected_trees)))
    TreeAdmin_UpdateGUI(handles);
end



% --- Executes when entered data in editable cell(s) in Details.
function Details_CellEditCallback(~, eventdata, handles)
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
function figure1_WindowKeyPressFcn(~, eventdata, handles)
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
function figure1_WindowKeyReleaseFcn(~, eventdata, handles)
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
function Animal_ButtonDownFcn(hObject, ~, handles)
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

% --- Executes on key press with focus on Trees box.
function Animal_KeyPressFcn(~, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA
if strcmp(eventdata.Key,'delete')
    delete_these_animals = handles.filter.filtered_animals(handles.filter.selected_animals);
    for n = 1:numel(delete_these_animals)
        delete_these = cellfun(@(x) strcmp(x.animal,delete_these_animals{n}),handles.admin.all_trees);
        if any(delete_these)
            handles.admin.deleted_trees(delete_these) = true;
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
function Trees_ButtonDownFcn(~, ~, handles)
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

% --- Executes on key press with focus on Trees box.
function Trees_KeyPressFcn(~, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA
if strcmp(eventdata.Key,'delete')
    handles.admin.deleted_trees(cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2})) = true;
    handles.filter.changed = 1;
    TreeAdmin_UpdateGUI(handles);
end

% --- Executes on button press in Legend_ok.
function Legend_ok_Callback(hObject, ~, handles)
% hObject    handle to Legend_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    legend(handles.Preview,handles.filter.filtered_tree_names(handles.filter.selected_trees,1))
else
    legend(handles.Preview,'off')
end


% --- Executes on button press in Preview_ok.
function Preview_ok_Callback(hObject, ~, handles)
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
function Details_ButtonDownFcn(~, ~, handles)
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
function Details_CellSelectionCallback(~, eventdata, handles)
% hObject    handle to Details (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
handles.admin.selected_detail = eventdata.Indices;
guidata(handles.TreeAdmin,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, ~, ~)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
answer = questdlg('Do you really want to close TreeAdmin?','Quit TreeAdmin','No');
if strcmp(answer,'Yes')
    if strcmp(get(hObject,'waitstatus'),'waiting')
        uiresume(hObject)
    else
        delete(hObject);
    end
end


% --- Executes on button press in Lock_ok.
function Lock_ok_Callback(hObject, ~, handles)
% hObject    handle to Lock_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.admin.locktreelist_ok = get(hObject,'Value');
set(hObject,'ForegroundColor',[handles.admin.locktreelist_ok 0 0])
s = {'on','off'};
set(handles.Animal,'Enable',s{handles.admin.locktreelist_ok+1})
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in check_notdone.
function check_notdone_Callback(hObject, ~, handles)
% hObject    handle to check_notdone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filter.check_notdone = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);

% --- Executes on button press in check_done.
function check_done_Callback(hObject, ~, handles)
% hObject    handle to check_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.filter.check_done = get(hObject,'Value');
handles.filter.changed = 1;
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in Start_Stats.
function Start_Stats_Callback(~, ~, handles)
% hObject    handle to Start_Stats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TreeAdmin_Statistics(handles.admin.stat_trees(:,1), handles.admin.stat_trees(:,2))



% --- Executes on button press in Add_Stat_Trees.
function Add_Stat_Trees_Callback(~, ~, handles)
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
function Del_Stat_Trees_Callback(~, ~, handles)
% hObject    handle to Del_Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
del_this_group = get(handles.Stat_Trees,'Value');
handles.admin.stat_trees(del_this_group,:) = [];
TreeAdmin_UpdateStats(handles);
guidata(handles.TreeAdmin,handles);


% --- Executes on button press in Save_Stat_Trees.
function Save_Stat_Trees_Callback(~, ~, handles)
% hObject    handle to Save_Stat_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName]  = uiputfile('*.mtr','Choose Folder and File Name to save Statistics Tree groups.','StatTrees.mtr');
if ~ischar(FileName)
    return
end
save_tree(handles.admin.stat_trees(:,1),fullfile(PathName,FileName));

% --------------------------------------------------------------------
function Rescale_Trees_ClickedCallback(~, ~, handles)
% hObject    handle to Rescale_Trees (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
new_scale = inputdlg('Please enter new scale','Rescale Trees',1,{'[0.4112,0.4112,1.5]'});
new_scale = str2double(new_scale{1});
if numel(new_scale)~=3 || isempty(new_scale)
    return
end
w = waitbar(0,'Please wait...');
for i = 1: numel(handles.filter.selected_trees)
    tree = handles.admin.all_trees{handles.filter.filtered_tree_names{handles.filter.selected_trees(i),2}};
    if isfield(tree,'x_scale') && ~isempty(tree.x_scale)
        fac = [new_scale(1)/tree.x_scale, new_scale(2)/tree.y_scale, new_scale(3)/tree.z_scale];
    else
        fac = [new_scale(1), new_scale(2), new_scale(3)];
    end
    tree.x_scale = new_scale(1);
    tree.y_scale = new_scale(2);
    tree.z_scale = new_scale(3);
    ORI = [tree.X(1) tree.Y(1) tree.Z(1)];  %origin of tree
    tree.X = tree.X -ORI(1);
    tree.Y = tree.Y -ORI(2);
    tree.Z = tree.Z -ORI(3);
    ORI = ORI .* fac;           %translate origin to new xyz_scale
    tree.X = tree.X +ORI(1);
    tree.Y = tree.Y +ORI(2);
    tree.Z = tree.Z +ORI(3);
    if fac(1) == fac(2)     % if new x_scale = new y_scale do scale them separately to z, so that diameter is also scaled
       tree = scale_tree(tree,fac(1)); 
       fac = fac/fac(1);
    end

    handles.admin.all_trees{handles.filter.filtered_tree_names{handles.filter.selected_trees(i),2}} = resample_tree(scale_tree (tree, fac),1,'-d');
    waitbar(i/numel(handles.filter.selected_trees),w)
end
close(w);
guidata(handles.TreeAdmin,handles);
TreeAdmin_UpdateGUI(handles);


%---------------------------------------------
function handles = reset_filter(handles)
fnames = fieldnames(handles.filter);
fnames = fnames(cellfun(@(x) ~isempty(strfind(x,'check_')),fnames));
for f = 1:numel(fnames)
    handles.filter.(fnames{f}) = false;
    set(handles.(fnames{f}),'Value',0)
end


% --- Executes on button press in make_sorted_files.
function make_sorted_files_Callback(~, ~, handles)
% hObject    handle to make_sorted_files (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tdir = uigetdir(pwd,'Please choose directory to save tree files in');
if ~ischar(tdir)
    return
end
answer = inputdlg('Please give specification of tree (e.g. all or sure etc.)','Tree Specification',1,{'all'});
if ~ischar(answer{1})
    return
end
dpi = cellfun(@(x) double(x.dpi),handles.admin.all_trees);
udpi = unique(dpi);
side = 1+ cellfun(@(x) strcmp(x.lateral_side,'ipsi'),handles.admin.all_trees) + 2*cellfun(@(x) strcmp(x.lateral_side,'contra'),handles.admin.all_trees) ; % 1 is all, 2 is ipsi, 3 is contra
blade = 1 + cellfun(@(x) strcmp(x.pyramidal_blade,'supra'),handles.admin.all_trees) + 2 * cellfun(@(x) strcmp(x.pyramidal_blade,'infra'),handles.admin.all_trees);  % 1 is all, 2 is supra, 3 is infra
compl = cellfun(@(x) x.completeness,handles.admin.all_trees);

sid = {'ALL','ipsi','contra'};
blad = {'ALL','supra','infra'};
w = waitbar(0,'Please wait...');
for u = 1:numel(udpi)+1
    for s = 1:numel(sid)
        for b = 1:numel(blad)
            for c = [0, 70, 80, 90]
                these_trees = handles.admin.filter' & compl >= c;
                if s ~= 1
                    these_trees = these_trees & side == s;
                end
                if b ~= 1
                    these_trees = these_trees & blade == b;
                end
                if u ~= 1
                    these_trees = these_trees & dpi == udpi(u-1);
                end
                if b == 1 && s == 1
                    continue
                end
                if sum(these_trees) > 1
                    if u == 1
                        save_tree(handles.admin.all_trees(these_trees),fullfile(tdir,sprintf('ALL_%s_%s_%s_%d+.mtr',sid{s},blad{b},answer{1},c)));
                    elseif udpi(u-1) == 0
                        save_tree(handles.admin.all_trees(these_trees),fullfile(tdir,sprintf('Mature_%s_%s_%s_%d+.mtr',sid{s},blad{b},answer{1},c)));
                    else
                        save_tree(handles.admin.all_trees(these_trees),fullfile(tdir,sprintf('%ddpi_%s_%s_%s_%d+.mtr',udpi(u-1),sid{s},blad{b},answer{1},c)));
                    end
                end
            end
        end
    end
    waitbar(u/(numel(udpi)+1),w)
end
close(w)

function endfile = cat_groups(file)
endfile = cell(0);
for f = 1:numel(file)
    if size(file{f},1) > size(file{f},2)
        file{f} = file{f}';
    end
    endfile = cat(2,endfile,file{f});
end
    


% --- Executes on button press in Rotate_ok.
function Rotate_ok_Callback(hObject, ~, handles)
% hObject    handle to Rotate_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value')
    handles.admin.rotate_ok = true;
else
    handles.admin.rotate_ok = false;
end
TreeAdmin_UpdateGUI(handles);


% --- Executes on button press in x3d.
function x3d_Callback(~, ~, handles)
% hObject    handle to x3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
trees = handles.admin.all_trees(cat(1,handles.filter.filtered_tree_names{handles.filter.selected_trees,2}));

[tname, path] = uiputfile ('.x3d', 'export to x3d', 'tree.x3d');
if ~ischar(tname) && tname == 0
    return
end
if ~isempty(strfind(tname,'.x3d'))
    tname = tname(1:end-4);
end
for t = 1:numel(trees)
    if numel(trees)>1
        x3d_tree (trees{t}, fullfile(path,sprintf('%s_%03d.x3d',tname,t)),[],[],[], '-o')
    else
        x3d_tree (trees{t}, fullfile(path,[tname,'.x3d']),[],[],[], '-o')
    end
end
