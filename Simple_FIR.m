classdef Simple_FIR < handle
    properties %component
        UIFigure   matlab.ui.Figure 
        P1       matlab.ui.container.Panel 
        P2        matlab.ui.container.Panel 
        Ax1          matlab.graphics.axis.Axes
        Ax2          matlab.graphics.axis.Axes
        AxP1_1        matlab.graphics.axis.Axes
        AxP1_2        matlab.graphics.axis.Axes
        AxP2_2        matlab.graphics.axis.Axes
        F1         matlab.ui.Figure 
        ImportButton  matlab.ui.control.UIControl
        ConfirmButton  matlab.ui.control.UIControl
        Plotbutton   matlab.ui.control.UIControl
        ConvertButton  matlab.ui.control.UIControl
        clearButton   matlab.ui.control.UIControl
        Text1    matlab.ui.control.UIControl
        Text2    matlab.ui.control.UIControl
        Text3    matlab.ui.control.UIControl
        Text4    matlab.ui.control.UIControl
        Text5    matlab.ui.control.UIControl
        Title    matlab.ui.control.UIControl
        TextFreqlower    matlab.ui.control.UIControl
        TextFrequpper    matlab.ui.control.UIControl
        TextFreq    matlab.ui.control.UIControl
        selectFilter    matlab.ui.control.UIControl
    end
    
    properties %variables
        Audiofile;
        sample;
        converted;
    end
    
    methods(Access=private) %initialize
        
        function createComponents(app)
            % create UI figure
        app.UIFigure=figure;
        app.UIFigure.Color=[1 0.8 0.8];
        app.UIFigure.Units='Normalized';
        app.UIFigure.Position=[.01 .01 .975 .955];
        app.UIFigure.Name='FIR_FIlter';
        app.UIFigure.NumberTitle='off';
        app.UIFigure.MenuBar='none';
        app.UIFigure.ToolBar='none';
        app.UIFigure.WindowStyle='modal';
        app.UIFigure.Visible='on';
        
        
        end
        
        function createComponent(app)
            
% panel
                  %create P1
        app.P1=uipanel(app.UIFigure);
        app.P1.Position=[0.55 .05 .38 .90];
        app.P1.BackgroundColor=[1 0.6 .5];
     
          %create P2
        app.P2=uipanel(app.UIFigure);
        app.P2.Position=[0.03 .04 .38 .90];
        app.P2.BackgroundColor=[1 0.6 0.4];
%axis
         
        % to make the axis disappear
        app.Ax1=axes(app.UIFigure);
        app.Ax1.Visible='off';
        %Axis in P1-1
        app.AxP1_1=axes(app.P1,'Position',[0.09 .52 .85 .43]);
        app.AxP1_1.Visible='off';
        app.AxP1_1.Color=[.1 .8 .5];
        
        
        %Axis in P1-2
        app.AxP1_2=axes(app.P1,'Position',[0.09 .52 .85 .43]);
        app.AxP1_2.Visible='off';
        app.AxP1_2.Color=[1 .8 .5];
        
         %Axis in P2-2
        app.AxP2_2=axes(app.P2,'Position',[0 0 1.02 .52]);
        app.AxP2_2.Visible='off';
        app.AxP2_2.Color=[1 .8 .5];
%buttons
        
   %freq
      
    
        %TextFreqlower
        app.TextFreqlower=uicontrol(app.UIFigure,'Style','edit','units','normalized'...
             ,'String','1','Position',[.42 .40 .04 .04],'BackgroundColor',[1 .8 .4]);
        app.TextFreqlower.Callback=@(o,e)app.LowerFreqEntered(o,e);
          
         %TextFrequpper 
        app.TextFrequpper=uicontrol(app.UIFigure,'Style','edit','units','normalized'...
             ,'String','100','Position',[.50 .40 .04 .04],'BackgroundColor',[1 .8 .4]);
        app.TextFrequpper.Callback=@(o,e)app.UpperFreqEntered(o,e);
          
          % TextFre the static text
        app.TextFreq=uicontrol(app.UIFigure,'Style','text','units','normalized'...
             ,'String','please enter frequency interval','Position',[.415 .47 .127 .02],...
             'BackgroundColor',[1 .7 .5]);
          % selectFilter
        app.selectFilter=uicontrol(app.UIFigure,'Style','popupmenu','units','normalized'...
             ,'String',{'bandpass','low','high','stop'},'Position',[.45 .45 .06 .018],'BackgroundColor',[1 .7 .5]);
        app.selectFilter.Callback=@(o,e)app.filterSelected(o,e);
          
   % sample     
         
         % Text1 the lower bound of sample
        app.Text1=uicontrol(app.UIFigure,'Style','edit','units','normalized'...
             ,'String','1','Position',[.42 .62 .04 .04],'BackgroundColor',[1 .8 .4]);
        app.Text1.Callback=@(o,e)app.LowerboundEntered(o,e);
         
      
         % Text2 the upper bound of sample
        app.Text2=uicontrol(app.UIFigure,'Style','edit','units','normalized'...
             ,'String','10','Position',[.50 .62 .04 .04],'BackgroundColor',[1 .8 .4]);
        app.Text2.Callback=@(o,e) app.UpperboundEntered(o,e);
      
         % Text3 the static text
        app.Text3=uicontrol(app.UIFigure,'Style','text','units','normalized'...
             ,'String','please enter sampled interval in time','Position',[.41 .67 .14 .02],...
             'BackgroundColor',[1 .7 .5]);
         % Text4 the static text
        app.Title=uicontrol(app.P2,'Style','text','units','normalized'...
             ,'String','STFT-based simple FIR :Project Description','FontSize',...
             14,'Position',[.12 .90 .76 .07],'HorizontalAlignment','center','BackgroundColor',[1 .9 .5]);
         % Text5  static
        app.Text4=uicontrol(app.P2,'Style','text','units','normalized'...
             ,'String',{'the description will be finished by Dec.15,2019'},'FontSize',...
             8,'HorizontalAlignment','center','Position',[.15 .88 .70 .03],'BackgroundColor',[.6 .6 .6]);
         
        % Text6  static
        app.Text4=uicontrol(app.P2,'Style','text','units','normalized',...
                'String',{'example', 'import fluteBassoon.mp3','put 190s-200s in time interval','use bandpass filter','filter out 1~120Hz','(flute is filtered out)'},'FontSize',...
                10,'HorizontalAlignment','left','Position',[.30 .74 .40 .13],'BackgroundColor',[1 .5 .4]);
         
         
   %funtional button
   
         %create inport button
        app.ImportButton=uicontrol(app.UIFigure,'Style','pushbutton',...
             'units', 'normalized','String','click to import',...
          'Position',[.44 .7 .07 .05],'BackgroundColor',[1 0.3 0.3]);
        app.ImportButton.Callback=@(o,e) app.ImportButtonPushed(o,e);
         %create confirm button
        app.ConfirmButton=uicontrol(app.UIFigure,'Style','pushbutton',...
             'units', 'normalized','String','click to confirm interval',...
          'Position',[.43 .58 .1 .03],'BackgroundColor',[1 0.3 0.3]);
        app.ConfirmButton.Enable='off';
        app.ConfirmButton.Callback=@(o,e) app.ConfirmButtonPushed(o,e);
         
         
         % Create Convert button
        app.ConvertButton=uicontrol(app.UIFigure,'Style','pushbutton',...
             'units', 'normalized','String','click to filter',...
          'Position',[.44 .51 .07 .05],'BackgroundColor',[1 0.3 0.3]);
        app.ConvertButton.Callback=@(o,e) app.ConvertButtonPushed(o,e);
        app.ConvertButton.Enable='off';
         
         % creat clearbutton
        app.clearButton=uicontrol(app.UIFigure,'Style','pushbutton',...
             'units', 'normalized','String','Clear all',...
          'Position',[.028 .95 .07 .045],'BackgroundColor',[1 0.3 0.3]);
        app.clearButton.Callback=@(o,e) app.ClearButtonPushed(o,e);
        
         
        end
    
    end
    
     methods(Access=private) %callback funtion

         % frequency callback
         function  LowerFreqEntered(app,~,~)
             if app.selectFilter.Value==1 || app.selectFilter.Value==4
                 if str2double(app.TextFreqlower.String)<=0
                     disp(str2double(app.Text1.String))
                     app.TextFreqlower.String='1';
                     app.TextFrequpper.String='100';
                 end
             end
         end
        
             % frequency callback
          function  UpperFreqEntered(app,~,~)            
             if app.selectFilter.Value==1 || app.selectFilter.Value==4
                 if str2double(app.TextFrequpper.String)<=0 || str2double(app.TextFrequpper.String)<=str2double(app.TextFreqlower.String)
                     app.TextFreqlower.String='1';
                     app.TextFrequpper.String='100';
                 end
             elseif str2double(app.TextFrequpper.String)<=0 
                     app.TextFrequpper.String='100';
             end
        end
         
         
         % filter selected callback
         function filterSelected(app,~,~)
                  
             switch  app.selectFilter.Value
                 case {2,3}
                     app.TextFreqlower.Visible='off';
                     app.TextFreqlower.String='-1';
                     app.TextFrequpper.Position=[.46 .4 .04 .04];
                 case {1,4}
                     app.TextFrequpper.Position=[.5 .4 .04 .04];
                      app.TextFreqlower.Visible='on';
                     app.TextFreqlower.String='1'; 
                     app.TextFrequpper.String='100'; 
                  
             end
         end
         
         
         %clear button call back 
         function ClearButtonPushed(app,~,~)
             delete(app.UIFigure.Children)
             createComponent(app)
             
         end
          %textbox1 callback
         function LowerboundEntered(app,~,~)
             if(str2double(app.Text1.String)<0)
                 app.Text2.String=10;
                 app.Text1.String=1;
             end
         end
         %textbox2 callback
         function UpperboundEntered(app,~,~)
             if(str2double(app.Text2.String)<str2double(app.Text1.String)||str2double(app.Text2.String)<0)
                 app.Text2.String=10;
                 app.Text1.String=1;
             end
         end
         
         % import button callback
         function ImportButtonPushed(app,~,~)
             Audio=uigetfile('*.mp3;*.wav');
             [y,Fs]=audioread(Audio);
             app.Audiofile.fs=Fs;
             app.Audiofile.data=y;
             app.ImportButton.Enable='off';
             app.ConfirmButton.Enable='on';
         end
         
        %confirm button call back
        function ConfirmButtonPushed(app,~,~)
             a=app.Audiofile.fs*str2double(app.Text1.String);
             b=app.Audiofile.fs*str2double(app.Text2.String); 
             %[y1,Fs]=audioread(Audio,[a,b]);
             y=app.Audiofile.data(a:b,:);
             s=size(y);
             switch s(2)
                 case 1
               Mono=y;
                 case 2
                  Mono=0.5*(y(:,1)+y(:,2));   
             end
               app.sample=Mono;   
               sound(Mono,app.Audiofile.fs)
               app.AxP1_1.Visible='on';
            %plotSpect(app,app.sample,app.Audiofile.fs,app.AxP1_1)
            str='Original';
            spectrooogram(app,app.sample,app.Audiofile.fs,app.AxP1_1,str)
            app.ImportButton.Enable='off';
            app.ConvertButton.Enable='on';
        end
        
        
        
        %covert button call back
        function ConvertButtonPushed(app,~,~)
            windowLength = 512; %hopsize 1/2*windowLength
            NFFT=1024;
            type_val=app.selectFilter.Value;
            type=app.selectFilter.String;
            type_str=type{type_val};
            fc1=str2double(app.TextFreqlower.String);
            fc2=str2double(app.TextFrequpper.String);
            Mono=app.sample;
            hlength=128;
            Fs=app.Audiofile.fs;
            X1=STFTsyn(app,windowLength,NFFT,Mono);
            H1=filter1(app,fc1,fc2,NFFT,Fs,hlength,type_str,type_val);
            yRec=reconstruction(app,Mono,windowLength,H1,X1,hlength);
            app.converted=yRec(1:length(Mono));
            sound(app.converted,Fs)
            str='Filtered';
            app.AxP1_2.Visible='on';
            spectrooogram(app,app.converted,app.Audiofile.fs,app.AxP1_2,str)
            %plotSpect(app,app.converted,app.Audiofile.fs,app.AxP1_2)
            app.ConfirmButton.Enable='off';
            
        end
         
        
     end
    
     
     
     
     
     methods(Access=private) %funtions
         function spectrooogram(~,samples,fs,parent,str)
             [S,F,T]=spectrogram(samples,512,128,2048,fs);
             [Nf,~]=size(S);
             S_one_sided=S(1:fix(length(F)/2),:);
             m=pcolor(parent,T,F(1:fix(Nf/2)),10*log10(abs(S_one_sided)));
             m.EdgeColor='none';
             shading interp;
             colormap(parent,jet);
             title(parent,['Spectrogram:',str]);
             xlabel(parent,'Time (s)');
             ylabel(parent,'Frequency (Hz)');
             colorbar(parent)
         end
        %{
         function plotSpect(~,samples,fs,parent)
              f=figure('visible','off');
             pspectrum(samples,fs,'spectrogram',...
             'FrequencyLimits',[0 10000],'TimeResolution',0.5)
             
             saveas(f,'sp1','png')
             I=imread('sp1.png');
             imwrite(I,'sp2.png','png','Transparency', [1 1 1] )
             I2=imread('sp2.png');
            
             %I2 = imresize(I2,1.4);
               
              
             imshow(I2,'Parent',parent)
         end
         %}
         function X1=STFTsyn(~,windowLength,NFFT,Mono)
             w = hamming(windowLength+1); % choose hamming window
             w=w(1:end-1);
             x = buffer(Mono, windowLength, windowLength/2); % 50%overlap
             x1_padding=zeros(NFFT-windowLength,ceil(length(Mono)/(windowLength/2)));
             x1 = (  x' * diag(w)  )'; %efficiently compute x*w on each block
             x1_padded=[x1;x1_padding];
             X1=[];% store each fft into the matrix
            for i=1:ceil(length(Mono)/(windowLength/2))
            X1(:,i)=fft(x1_padded(:,i));
             end 
         end
         
         function H1=filter1(~,fc1,fc2,NFFT,Fs,hlength,type_str,type_val)
             disp([type_val fc1 fc2] )
             switch type_val
                 case {1,4}
             h=fir1(hlength,[fc1/(Fs/2),fc2/(Fs/2)],type_str);
              case {2,3}
             h=fir1(hlength,fc2/(Fs/2),type_str);
             end
            h1=h(:);
            h1(end+1:NFFT)=0;
            H1=fft(h1);
         end
         
         function yRec=reconstruction(~,Mono,windowLength,H1,X1,hlength)
            y2=[];
             for l=1:ceil(length(Mono)/(windowLength/2))
            y2(:,l)=ifft(X1(:,l).*H1);
             end 
            y2(y2<1e-16)=0;
            y2=y2(1:(hlength+windowLength)-1,:);
            n=ceil(length(Mono)/(windowLength/2));
            yRec=zeros(n*((hlength+windowLength)-1)-(n-1)*(windowLength/2),1);
            for k=1:ceil(length(Mono)/(windowLength/2))
             a=(k-1)*windowLength/2+1;
            b=a+(hlength+windowLength)-2;
              yRec(a:b,1)=yRec(a:b,1)+y2(:,k);
             end 

         end
         
     end
     
    %constructor 
    methods  (Access=public)
        function app= Simple_FIR
            close all; 
            %creat components and figures
              createComponents(app)
            createComponent(app)
             hold on
             if nargout == 0                   
                 %delete(app)         
             end 
        end
    end 
    
    
    methods  (Access=public)
    
        function delete(app)
            warning off
            delete(app.UIFigure);
        end 
        
        
    end 
    
    
    
    
end