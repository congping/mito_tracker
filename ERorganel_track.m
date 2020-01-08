function varargout = ERorganel_track(varargin)
% ERORGANEL_TRACK MATLAB code for ERorganel_track.fig
%      ERORGANEL_TRACK, by itself, creates a new ERORGANEL_TRACK or raises the existing
%      singleton*.
%
%      H = ERORGANEL_TRACK returns the handle to a new ERORGANEL_TRACK or the handle to
%      the existing singleton*.
%
%      ERORGANEL_TRACK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERORGANEL_TRACK.M with the given input arguments.
%
%      ERORGANEL_TRACK('Property','Value',...) creates a new ERORGANEL_TRACK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ERorganel_track_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ERorganel_track_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% global_thresh_edit the above text to modify the response to help ERorganel_track

% Last Modified by GUIDE v2.5 08-Jan-2020 12:28:35

% Begin initialization code - DO NOT GLOBAL_THRESH_EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ERorganel_track_OpeningFcn, ...
                   'gui_OutputFcn',  @ERorganel_track_OutputFcn, ...
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
% End initialization code - DO NOT GLOBAL_THRESH_EDIT


% --- Executes just before ERorganel_track is made visible.
function ERorganel_track_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ERorganel_track (see VARARGIN)

% Choose default command line output for ERorganel_track
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ERorganel_track wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ERorganel_track_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on frame_slider movement.
function frame_slider_Callback(hObject, eventdata, handles)
% hObject    handle to frame_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of frame_slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of frame_slider
%tic
k=floor(get(handles.frame_slider,'Value'));
set(handles.frame_slider_edit,'string',num2str(floor(get(handles.frame_slider,'Value'))));
frame_slider_n(hObject,eventdata,handles,k);

%toc

function frame_slider_n(hObject,eventdata,handles,k)
global mov tracks_1 tracks_2 boundary_1 boundary_2 select_traj  

s=get(handles.process_channel_menu,'string');
n=get(handles.process_channel_menu,'Value');% channel number
channel=str2num(char(s(n)));
    
set(handles.frame_slider,'Value',k)
cla reset
h=handles.im_axes;
axes(h)
contents=get(handles.channel_view_menu,'Value');
B=double(mov(k).cdata);
%imageHandle=imagesc(B,'Parent', handles.im_axes);
%imageHandle=imagesc(B./max(B(:)),'Parent', handles.im_axes);
if contents==1
   imageHandle=imagesc(B./max(B(:)),'Parent', handles.im_axes);
else
    imageHandle=imagesc(B(:,:,contents-1),'Parent', handles.im_axes);
end
hold on
%set(handles.im_axes,'CurrentAxes');   
set(imageHandle,'ButtonDownFcn',{@im_axes_ButtonDownFcn,handles});%ImageClickCallback);

if get(handles.detect_checkbox,'Value')==1  % && get(handles.select_checkbox,'Value')==0
  eval(['tracks=tracks_',num2str(channel),';']);
  eval(['boundary0=boundary_',num2str(channel),';']);
  flag=get(handles.boundary_radiobutton,'Value');
  if ~isempty(tracks)
      ind=find(tracks(:,3)==k);      
      %plot(tracks(ind,1),tracks(ind,2),'ko')
      for kk=1:length(ind)
          plot(tracks(ind(kk),1),tracks(ind(kk),2),'ko')
          if false%~isempty(boundary0) && flag
              if false%true %boundary0(ind(kk)).type==0
                  plot(boundary0(ind(kk)).boundary(:,2),boundary0(ind(kk)).boundary(:,1),'k.','MarkerSize',6)
              elseif boundary0(ind(kk)).type==1
                  plot(boundary0(ind(kk)).boundary(:,2),boundary0(ind(kk)).boundary(:,1),'b.','MarkerSize',3)
              elseif boundary0(ind(kk)).type==2
                  plot(boundary0(ind(kk)).boundary(:,2),boundary0(ind(kk)).boundary(:,1),'m.','MarkerSize',3)
              end
                  
          end
      end
  end

end

if get(handles.track_checkbox,'Value')==1 && k>1  %&& get(handles.select_checkbox,'Value')==0
    % line between previous obj and current one

    
    if size(tracks,2)==4
        ind= tracks(:,3)==k; %% track, position x y, time, ID
        ID=tracks(ind,4);
        len=str2double(get(handles.track_step_edit,'string'));
     %   hold on
        if isempty(select_traj)
            IDs=[];
        else
            IDs=cat(1,select_traj.ID);
        end
        if ~isempty(ID)
            for i=1:length(ID)
                ii=ID(i);
                ind= find(tracks(:,4)==ii & tracks(:,3)<=k+len & tracks(:,3)>=k);%-len;
                pks=tracks(ind,:);  
                pks1=sortrows(pks,3);
                if ~isempty(pks)
                    if isempty(intersect(ii,IDs))
                        plot(pks1(:,1),pks1(:,2),'Color',[1 1 1])
                       % if ~isempty(boundary_1)
                        %    for kk=1:length(ind)
                         %     plot(boundary_1(ind(kk)).boundary(:,2),boundary_1(ind(kk)).boundary(:,1),'y.','MarkerSize',5)
                          %  end
                        %end
                    else% selected ID
                        plot(pks1(:,1),pks1(:,2),'Color',[1 0 0])
                        ind1=find(pks(:,3)==k);                        
                        for kk=1:length(ind1)
                            plot(pks(ind1(kk),1),pks(ind1(kk),2),'ro')
                            if ~isempty(boundary_1)
                            plot(boundary_1(ind(ind1(kk))).boundary(:,2),boundary_1(ind(ind1(kk))).boundary(:,1),'y.','MarkerSize',5)
                            end
                        end 
                        if length(ind1)>1
                            break
                            message  = sprintf('error: one ID at one time');
                            helpdlg(message)
                        end
                    end
                end
            end
        end
    end
    
end






% --- Executes on button press in detect_button.
function detect_button_Callback(hObject, eventdata, handles)
% hObject    handle to detect_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global mov tracks_1 boundary_1 tracks_2 tracks_3 boundary_2 boundary_3 
%x = inputdlg('Which channel (enter 1, 2 or 3) ?');%, [1 3]);
s=get(handles.process_channel_menu,'string');
n=get(handles.process_channel_menu,'Value');% channel number

if n>=2 || size(mov(1).cdata,3)==1%~isempty(x)
    channel=str2num(char(s(n)));
%channel = str2num(x{:}); 
% k=floor(get(handles.frame_slider,'Value'));
sigma=str2double(get(handles.sigma_edit,'string'));
threshold=str2double(get(handles.threshold_edit,'string'));
diameter=str2num(get(handles.diameter_edit,'string'));
method=get(handles.popupmenu_method,'Value');
G=fspecial('gaussian',[diameter,diameter],sigma);
set(handles.detect_button,'string','runnng');
if method==1
    [tracks, boundary0]=detectObj_max(mov,channel, sigma, threshold, diameter,3,10,false,false);%(mov,channel, sigma, threshold, diameter,pixdis,componentsize,flagboundary,flagsoc3)
elseif method==2     % center
    [tracks, boundary0]=detectsignleObj(mov,G,threshold,false);
elseif method==3  % using houghcircles
    [tracks, boundary0]=detectObj_houghcircle(mov,channel,G,sigma,threshold, 4,pixdis,4,false);
elseif method==4 %object center
    [tracks, boundary0]=detectmultiObjCenter(mov,channel,G,threshold,false,false);            
end

%channel=1;
eval(['tracks_',num2str(channel),'=tracks;']);
eval(['boundary_',num2str(channel),'=boundary0;']);
set(handles.detect_button,'string','detect');
set(handles.track_button,'enable','on')
else
    display('channel is not selected')
end
%mean(Ar)



% --- Executes on button press in detect_checkbox.
function detect_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to detect_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detect_checkbox

frame_slider_Callback(hObject, eventdata, handles)




% --- Executes on button press in track_checkbox.
function track_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to track_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of track_checkbox

%global mov

%k=floor(get(handles.frame_slider,'Value'));
%if (get(hObject,'Value')==1)
frame_slider_Callback(hObject, eventdata, handles)




% --- Executes on button press in ER_seperate_checkbox.





% --- Executes on button press in track_button.
function track_button_Callback(hObject, eventdata, handles)
% hObject    handle to track_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tracks_1 boundary_1 tracks_2 boundary_2 %tracks_2 tracks_3
% x = inputdlg('Enter f1, 2 or 3 to track from one channel ?');%, [1 3]);
% n = str2num(x{:}); 
% if (length(n)~=1)
%     display('entered channel incorrected')
% else
%n=1;
s=get(handles.process_channel_menu,'string');
k=get(handles.process_channel_menu,'Value');% channel number
n=str2num(char(s(k)));

eval(['tracks0=tracks_',num2str(n),';']);
eval(['boundary0=boundary_',num2str(n),';']);
%set(hObject,'enable','off');
mdis=str2double(get(handles.distance_edit,'string'));
param.mem=0;
param.good=0;
param.dim=2;
param.quiet=0;
if (size(tracks0,2)>3)
    tracks0=sortrows(tracks0,3);
end
tracks_new=mytrack(tracks0(:,:),mdis,param);
eval(['tracks_',num2str(n),'=tracks_new;']);
if ~isempty(boundary0)
for i=1:length(tracks_new)
    j=find(tracks_new(i,1)==tracks0(:,1) & tracks_new(i,2)==tracks0(:,2) & tracks_new(i,3)==tracks0(:,3));
    boundary_new(i)=boundary0(j);
end
eval(['boundary_',num2str(n),'=boundary_new;']);
end
%end
%set(hObject,'enable','on');



% --- Executes on button press in check_checkbox.
function check_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to check_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_checkbox
global mov tracks_1 tracks_2 tracks_3

% 3D test tracking
if get(hObject,'Value')==1
    x = inputdlg('Enter 1, 2 or 3 to test tracks from one channel?');%, [1 3]);
    m = str2num(x{:}); 
    eval(['tracks=tracks_',num2str(m),';']);
    h=figure(1);
%set(gca,'nextplot','replacechildren');
k=floor(get(handles.frame_slider,'Value'));
%cla(h_test);
test_tracks(tracks,mov,k)
end







% --- Executes on selection change in channel_view_menu.
function channel_view_menu_Callback(hObject, eventdata, handles)
% hObject    handle to channel_view_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channel_view_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channel_view_menu

frame_slider_Callback(hObject, eventdata, handles)




% --- Executes on selection change in save_menu.
function save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns save_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from save_menu
global mov tracks_1 tracks_2 boundary_1 boundary_2  speed er filename select_traj 
contents=get(hObject,'Value');

s=get(handles.process_channel_menu,'string');
n=get(handles.process_channel_menu,'Value');% channel number
channel=str2num(char(s(n)));
eval(['tracks=tracks_',num2str(channel),';']);
eval(['boundary0=boundary_',num2str(channel),';']);

if contents==1
    display('no data selected');
elseif contents==2
    %x = inputdlg('Which channel (enter 1, 2 or 3) of tracks to save ?');%, [1 3]);
    uisave({'tracks_1','select_traj'},strcat('tracks_',filename(1:end-4)));

end




function track_step_edit_Callback(hObject, eventdata, handles)
% hObject    handle to track_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of track_step_edit as text
%        str2double(get(hObject,'String')) returns contents of track_step_edit as a double


% --- Executes during object creation, after setting all properties.
function track_step_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track_step_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function im_axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to im_axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 global tracks_1  boundary_1  tracks_2  boundary_2 select_traj 
s=get(handles.process_channel_menu,'string');
k=get(handles.process_channel_menu,'Value');% channel number
n=str2num(char(s(k)));

eval(['tracks0=tracks_',num2str(n),';']);
eval(['boundary0=boundary_',num2str(n),';']);


 axesHandle  = get(hObject,'Parent');
 coordinates = get(axesHandle,'CurrentPoint');
 coordinates = coordinates(1,1:2); % horizontal and verticle
 message     = sprintf('x: %.1f , y: %.1f',coordinates (1) ,coordinates (2));
 helpdlg(message);
 if get(handles.select_checkbox,'Value')==1
     h=handles.im_axes;
     axes(h)
     hold on
     k=floor(get(handles.frame_slider,'Value'));
     select_traj=select_deselect(tracks0,boundary0,select_traj,coordinates,k);  
     
 end






% 
% --- Executes during object creation, after setting all properties.
function join_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to join_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% 

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% if get(hObject,'Value') 
%         
% end




% --- Executes on selection change in popupmenu_method.
function popupmenu_method_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_method


% --- Executes during object creation, after setting all properties.
function popupmenu_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function load_movie_Callback(hObject, eventdata, handles)
% hObject    handle to load_movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clear all
global mov mov_seperate filename  tracks_1 tracks_2 

tracks_1=[];
tracks_2=[];
mov=struct('cdata',[]);
mov_seperate=struct('cdata',[]);
%[filename, user_cancelled] = imgetfile;
[filename,pathname,FilterIndex] = uigetfile({'*.tif';' *.avi'},'Select image data');
n=get(handles.channel_no_menu,'Value');% channel number
s=get(handles.channel_no_menu,'string');
Nchannel=str2num(char(s(n)));

if filename==0%user_cancelledup
            disp('User pressed cancel')
            set(handles.file_text,'string','file name');
else
            disp(['User selected ', filename])
            video=strcat(pathname,filename);
            set(handles.filename_text,'string',video);
            if FilterIndex==2
            mov=readAviMovie(video);
            elseif FilterIndex==1
                if Nchannel==2% ER-organelle 2 channel tif
                    mov=readER_MT_TifMovie(video);
                elseif Nchannel ==1 || Nchannel ==3
                    mov=readTifMovie(video);
                else
                    display('unable to red this tif movie');
                end
            end
%mov(1:length(mov)-150)=[];
%mov(101:end)=[];
nFrames=length(mov);
mov_seperate=repmat(mov_seperate,1,nFrames);
set(handles.frame_slider,'Min',1);
set(handles.frame_slider,'Max',nFrames);
set(handles.frame_slider, 'Value', 1);
set(handles.frame_slider, 'SliderStep', [1/(nFrames-1) , 10/(nFrames-1) ]);


%set(handles.persistent_button,'Value',1);
%set(handles.check_checkbox,'Value',1);
%set(handles.type_pushbutton,'Value',1);
h=handles.im_axes;
axes(h)
cla
B=double(mov(1).cdata);
imageHandle=imagesc(B./max(B(:)));
axis([1 size(mov(1).cdata(:,:,1),2) 1 size(mov(1).cdata(:,:,1),1)])
axis equal
%axis off
end
%set(hObject, 'pointer', 'arrow')
set(imageHandle,'ButtonDownFcn',{@im_axes_ButtonDownFcn,handles});%ImageClickCallback);

set(handles.detect_checkbox,'Value',0);
set(handles.track_checkbox,'Value',0);
set(handles.type_pushbutton,'Value',0);
set(handles.persistent_checkbox,'Value',0);
set(handles.ER_seperate_checkbox,'Value',0);
set(handles.binary_checkbox,'Value',0);




% --------------------------------------------------------------------
function load_track_Callback(hObject, eventdata, handles)
% hObject    handle to load_track (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global tracks_1 boundary_1 select_traj

n=get(handles.process_channel_menu,'Value');% channel number
s=get(handles.process_channel_menu,'string');
Nchannel=str2num(char(s(n)));


%path=pwd;
[filename1,filepath1]=uigetfile({'*.mat','All Files'}, 'Select track file'); 
str=strcat(filepath1,filename1);
a=load(str);
tracks_1=a.tracks_1;
boundary_1=a.boundary_1;

select_traj=a.select_traj;



function split_button_Callback(hObject, eventdata, handles)
% hObject    handle to split_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of split_button as text
%        str2double(get(hObject,'String')) returns contents of split_button as a double
global select_traj tracks_1 tracks_2


s=get(handles.process_channel_menu,'string');
k1=get(handles.process_channel_menu,'Value');% channel number
n=str2num(char(s(k1)));

eval(['tracks0=tracks_',num2str(n),';']);


k=floor(get(handles.frame_slider,'Value'));
ID=select_traj.ID;
if length(select_traj)==1
IDmax=max(tracks0(:,4));
%ind=find(tracks_3(:,4)==ID);
m=find(tracks0(:,4)==ID & tracks0(:,3)<=k);
% break the track from [ind(1),m],(m,ind(end)]
tracks0(m,4)=IDmax+1;
eval(['tracks_',num2str(n),'=tracks0;']);
else
    display('number of selectr tracks to split is not correct!')
end



% --- Executes on key press with focus on frame_slider_edit and none of its controls.
function frame_slider_edit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to frame_slider_edit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
k=str2num(get(handles.frame_slider_edit,'String'));
frame_slider_n(hObject,eventdata,handles,k);


% --- Executes on button press in select_checkbox.
function select_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to select_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global select_traj
if get(hObject,'Value')==0
    select_traj=[];
    frame_slider_Callback(hObject, eventdata, handles)
%    set(handles.relative_speed_button,'enable','off');
end


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in join_button.
function join_button_Callback(hObject, eventdata, handles)
% hObject    handle to join_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tracks_1 tracks_2 select_traj

s=get(handles.process_channel_menu,'string');
k=get(handles.process_channel_menu,'Value');% channel number
n=str2num(char(s(k)));

eval(['tracks0=tracks_',num2str(n),';']);
%eval(['boundary0=boundary_',num2str(n),';']);


if length(select_traj)==2
ID1=select_traj(end-1).ID;
ID2=select_traj(end).ID;
tracks0=joinTracks(tracks0,ID1,ID2);
eval(['tracks_',num2str(n),'=tracks0;']);
else
    display('number of selectr tracks to join is not correct!')
end






% --- Executes on selection change in process_channel_menu.
function process_channel_menu_Callback(hObject, eventdata, handles)
% hObject    handle to process_channel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns process_channel_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from process_channel_menu


% --- Executes during object creation, after setting all properties.
function process_channel_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to process_channel_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in channel_no_menu.
function channel_no_menu_Callback(hObject, eventdata, handles)
% hObject    handle to channel_no_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_no_menu
n=get(hObject,'Value');% channel number
s=get(hObject,'string');
Nchannel=str2num(char(s(n)));
s2=get(handles.process_channel_menu,'string');

for k=1:Nchannel
    s2{k+1}=num2str(k);
end

set(handles.process_channel_menu,'string',s2);

s3=get(handles.channel_view_menu,'string');

if Nchannel==3
    s3{2}='red';
    s3{3}='green';
    s3{4}='blue';
elseif Nchannel==2
    s3={s3{1},s3{2},s3{3}};
%elseif Nchannel==1
 %   s3=s3{1};
end
set(handles.channel_view_menu,'string',s3);


% --- Executes during object creation, after setting all properties.
function polygon_pushbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polygon_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ER_flow_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ER_flow_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function ER_flow_checkbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ER_flow_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function polygon_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polygon_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
