function colourAtla
% @author slandarer

% 颜色数量
colorNum = 6;% 初始颜色列表
colorList=[189  115  138; 237  173  158
           140  199  181; 120  205  205
            79  148  205; 205  150  205];
% 颜色格式
% [0 1]   -> 1
% [0 255] -> 2
% #hex    -> 3
% hsv     -> 4
colorType=3;
% colormap名称（用于Tecplot/MATLAB导出）
colormapName='';
% 当前导出格式
exportFormat='COMSOL';
% 三维图片矩阵
oriPic=[];
% RGB数据列
RGBList=[];
% =========================================================================
% figure窗口构建
atlaFig=uifigure('units','pixels');
atlaFig.Position=[10,65,820,660];
atlaFig.NumberTitle='off';
atlaFig.MenuBar='none';
atlaFig.Name='colour atla 2.0 | by jc';
atlaFig.Color=[1,1,1];
atlaFig.Resize='off';
% 显示图像axes区域
imgAxes=uiaxes('Parent',atlaFig);
imgAxes.Position=[10,130,480,480];
imgAxes.XLim=[0,100];
imgAxes.YLim=[0,100];
imgAxes.XTick=[];
imgAxes.YTick=[];
imgAxes.Box='on';
imgAxes.Toolbar.Visible='off';
% 显示色卡axes区域
atlaAxes=uiaxes('Parent',atlaFig);
atlaAxes.Position=[500,180,240,420];
atlaAxes.XLim=[0,240];
atlaAxes.YLim=[0,400];
atlaAxes.XTick=[];
atlaAxes.YTick=[];
atlaAxes.Box='on';
atlaAxes.Toolbar.Visible='on';
hold(atlaAxes,'on')
% 重绘色卡函数
function freshColorAtla(~,~)
    hold(atlaAxes,'off')
    plot(atlaAxes,[-1,-1],[-1,-1]);
    hold(atlaAxes,'on')
    text(atlaAxes,10,370,'Colour Atla','FontName','Cambria','FontSize',21);
    for i=1:size(colorList,1)
        fill(atlaAxes,[10 120 120 10],[370 370 390 390]-50-28*(i-1),colorList(i,:)./255)
        switch colorType
            case 1 % 显示RGB [0 1]格式颜色数据
                tempColorR=sprintf('%.2f',colorList(i,1)./255);
                tempColorG=sprintf('%.2f',colorList(i,2)./255);
                tempColorB=sprintf('%.2f',colorList(i,3)./255);
                text(atlaAxes,133,330-28*(i-1),...
                    [tempColorR,' ',tempColorG,' ',tempColorB],...
                    'FontName','Cambria','FontSize',16);
            case 2 % 显示RGB[0 255]格式颜色数据
                text(atlaAxes,135,330-28*(i-1),...
                    [num2str(colorList(i,1)),' ',...
                     num2str(colorList(i,2)),' ',...
                     num2str(colorList(i,3))],...
                    'FontName','Cambria','FontSize',16);
            case 3 % 显示16进制格式颜色数据
                exchange_list={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
                tempColor16='#';
                for ii=1:3
                    temp_num=colorList(i,ii);
                    tempColor16(1+ii*2-1)=exchange_list{(temp_num-mod(temp_num,16))/16+1};
                    tempColor16(1+ii*2)=exchange_list{mod(temp_num,16)+1};
                end
                text(atlaAxes,135,330-28*(i-1),tempColor16,'FontName','Cambria','FontSize',16);
            case 4 % 显示hsv格式颜色数据
                [h,s,v]=rgb2hsv(colorList(i,1),colorList(i,2),colorList(i,3));
                text(atlaAxes,130,330-28*(i-1),...
                    [sprintf('%.2f',h),'  ',...
                     sprintf('%.2f',s),'  ',...
                     num2str(v)],...
                     'FontName','Cambria','FontSize',16);
        end
    end
    outputData()
    if exist('colorTable','var')
        colorTable.Data = double(colorList);
    end
end
freshColorAtla()
% =========================================================================
% 选择k-means k值按钮（颜色数量按钮）
uilabel('parent',atlaFig,'Text','  ColorNum','FontName','Cambria','FontWeight','bold',...
    'FontSize',15,'BackgroundColor',[0.31 0.58 0.80],'position',[500,150,80,25],'FontColor',[1 1 1]);
CNsetBtn=uispinner(atlaFig,'Value',2,'limit',[2 12],'FontName','Cambria','Step',1,...
    'ValueDisplayFormat','%.f','FontSize',14,'ValueChangedFcn',@CNset,'position',[580,150,50,25]);
function CNset(~,~)% color number set function
    colorNum=CNsetBtn.Value;
end
% 选择颜色类型按钮
uilabel('parent',atlaFig,'Text','  ColorType','FontName','Cambria','FontWeight','bold',...
    'FontSize',15,'BackgroundColor',[0.31 0.58 0.80],'position',[500,123,90,25],'FontColor',[1 1 1]);
TPsetBtnGp=uidropdown('parent',atlaFig);
TPsetBtnGp.Items={'  [0 1]';'[0 255]';'  #hex';'  HSV'};
TPsetBtnGp.ValueChangedFcn=@TPset;
TPsetBtnGp.Position=[580,123,70,25];
TPsetBtnGp.Value='  #hex';
function TPset(~,~)% color type set function
    switch TPsetBtnGp.Value
        case '  [0 1]',colorType=1;
        case '[0 255]',colorType=2;
        case '  #hex', colorType=3;
        case '  HSV',  colorType=4;
    end
    freshColorAtla()
end

% 导入图片按钮
uibutton(atlaFig,'Text','Load Img','BackgroundColor',[0.59 0.71 0.84],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[630,150,100,25],'FontName','Cambria','FontSize',15,'ButtonPushedFcn',@LDimg);
function LDimg(~,~)
    try
        [filename, pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
            '*.*','All Files' });
        oriPic=imread([pathname,filename]);
        [imgXLim,imgYLim,~]=size(oriPic);
        len=max([imgXLim,imgYLim]);
        imgAxes.XLim=[0 len];
        imgAxes.YLim=[0 len];
        hold(imgAxes,'off')
        imshow(oriPic,'Parent',imgAxes)
        RGBList=double(reshape(oriPic,prod(size(oriPic,[1,2])),3));
    catch
    end
end
% 导入colormap文件按钮
uibutton(atlaFig,'Text','Import Map','BackgroundColor',[0.59 0.71 0.84],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[735,150,85,25],'FontName','Cambria','FontSize',13,'ButtonPushedFcn',@importMapCallback);

% 导出格式选择
uilabel('parent',atlaFig,'Text','  Format','FontName','Cambria','FontWeight','bold',...
    'FontSize',13,'BackgroundColor',[0.31 0.58 0.80],'position',[500,96,60,25],'FontColor',[1 1 1]);
formatDD=uidropdown('parent',atlaFig);
formatDD.Items={'COMSOL','Origin','Tecplot','MATLAB'};
formatDD.ValueChangedFcn=@onFormatChanged;
formatDD.Position=[560,96,70,25];
formatDD.Value='COMSOL';

% colormap名称输入
nameLabel=uilabel('parent',atlaFig,'Text','  Name','FontName','Cambria','FontWeight','bold',...
    'FontSize',13,'BackgroundColor',[0.31 0.58 0.80],'position',[635,96,50,25],'FontColor',[1 1 1]);
nameField=uieditfield('parent',atlaFig,'Position',[685,96,80,25],...
    'FontName','Cambria','FontSize',13,'Value','');
nameLabel.Enable='off';
nameField.Enable='off';

% 导出按钮
uibutton(atlaFig,'Text','Export','BackgroundColor',[0.59 0.71 0.84],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[770,96,50,25],'FontName','Cambria','FontSize',15,'ButtonPushedFcn',@exportMapCallback);

% 颜色数值编辑表格标签
uilabel('parent',atlaFig,'Text','Color Values (0-255)','FontName','Cambria','FontWeight','bold',...
    'FontSize',13,'BackgroundColor',[0.31 0.58 0.80],'position',[10,105,200,22],'FontColor',[1 1 1]);

% 反转顺序按钮
uibutton(atlaFig,'Text','Reverse','BackgroundColor',[0.59 0.71 0.84],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[410,105,80,22],'FontName','Cambria','FontSize',13,'ButtonPushedFcn',@onReverse);

% 颜色数值编辑表格
colorTable=uitable('parent',atlaFig,'Position',[10,10,480,90],...
    'ColumnName',{'R','G','B'},'ColumnEditable',[true,true,true],...
    'ColumnFormat',{'numeric','numeric','numeric'},'RowName','numbered',...
    'FontName','Cambria','FontSize',12,'Data',double(colorList),...
    'CellEditCallback',@onTableEdited);
% 开始聚类按钮
uibutton(atlaFig,'Text','RUN','BackgroundColor',[0.59 0.71 0.84],'FontColor',[1 1 1],...
    'FontWeight','bold','Position',[660,123,80,25],'FontName','Cambria','FontSize',15,'ButtonPushedFcn',@runKmeans);
function runKmeans(~,~)
    [~,C]=rgb2ind(oriPic,colorNum);
    C=round(NTraveler(C).*255);
    colorList=C;
    freshColorAtla()
end
% 命令行输出数据函数
function outputData(~,~)
    disp(['output time:',datestr(now)])
    disp('color list:')
    for i=1:size(colorList,1)
        switch colorType % 与色卡显示类似
            case 1
                tempData(i,:)=roundn(colorList(i,:)./255,-2);
            case 2
                tempData(i,:)=colorList(i,:);
            case 3
                exchange_list={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
                tempColor16='#';
                for ii=1:3
                    temp_num=colorList(i,ii);
                    tempColor16(1+ii*2-1)=exchange_list{(temp_num-mod(temp_num,16))/16+1};
                    tempColor16(1+ii*2)=exchange_list{mod(temp_num,16)+1};
                end
                tempData(i,1)={tempColor16};
            case 4
                [h,s,v]=rgb2hsv(colorList(i,1),colorList(i,2),colorList(i,3));
                tempData(i,:)=[h,s,v];
        end
    end
    disp(tempData);
end
function NCList=NTraveler(CList)
% 想法来自: Alan Zucconi
N=size(CList,1);
NCList=zeros(N,3);
ind=find(sum(CList,2)==min(sum(CList,2)),1);
NCList(1,:)=CList(ind,:);
CList(ind,:)=[];
for i=2:N
    lastColor=NCList(i-1,:);
    normList=vecnorm((lastColor-CList)');
    ind=find(normList==min(normList),1);
    NCList(i,:)=CList(ind,:);
    CList(ind,:)=[];
end
end

% =========================================================================
% 格式下拉回调
function onFormatChanged(~,~)
    switch formatDD.Value
        case {'Tecplot','MATLAB'}
            nameLabel.Enable='on';
            nameField.Enable='on';
        otherwise
            nameLabel.Enable='off';
            nameField.Enable='off';
    end
end

% 反转顺序回调
function onReverse(~,~)
    colorList=colorList(end:-1:1,:);
    freshColorAtla();
end

% 表格编辑回调
function onTableEdited(~,event)
    newData=colorTable.Data;
    newData=round(max(0,min(255,newData)));
    colorList=double(newData);
    colorTable.Data=double(colorList);
    freshColorAtla();
end

% =========================================================================
% 多格式导出回调
function exportMapCallback(~,~)
    fmt=formatDD.Value;
    switch fmt
        case 'COMSOL'
            [file,path]=uiputfile({'*.txt','COMSOL Colormap (*.txt)'},'Export for COMSOL');
            if isequal(file,0),return;end
            fid=fopen(fullfile(path,file),'w');
            fprintf(fid,'%% Continuous\n');
            for i=1:size(colorList,1)
                fprintf(fid,'%.4f %.4f %.4f\n',colorList(i,1)/255,colorList(i,2)/255,colorList(i,3)/255);
            end
            fclose(fid);
        case 'Origin'
            [file,path]=uiputfile({'*.pal','Origin JASC-PAL (*.pal)'},'Export for Origin');
            if isequal(file,0),return;end
            fid=fopen(fullfile(path,file),'w');
            fprintf(fid,'JASC-PAL\n0100\n%d\n',size(colorList,1));
            for i=1:size(colorList,1)
                fprintf(fid,'%d %d %d\n',colorList(i,1),colorList(i,2),colorList(i,3));
            end
            fclose(fid);
        case 'Tecplot'
            [file,path]=uiputfile({'*.map','Tecplot Macro (*.map)'},'Export for Tecplot');
            if isequal(file,0),return;end
            name=strtrim(nameField.Value);
            if isempty(name),name='MyColormap';end
            N=size(colorList,1);
            fid=fopen(fullfile(path,file),'w');
            fprintf(fid,'#!MC 1410\n');
            fprintf(fid,'$!CreateColorMap\n');
            fprintf(fid,'  Name = ''%s''\n',name);
            fprintf(fid,'  NumControlPoints = %d\n',N);
            for i=1:N
                frac=(i-1)/max(N-1,1);
                fprintf(fid,'  ControlPoint %d\n',i);
                fprintf(fid,'    {\n');
                fprintf(fid,'    ColormapFraction = %.6f\n',frac);
                fprintf(fid,'    LeadRGB\n');
                fprintf(fid,'      {\n');
                fprintf(fid,'      R = %d\n',colorList(i,1));
                fprintf(fid,'      G = %d\n',colorList(i,2));
                fprintf(fid,'      B = %d\n',colorList(i,3));
                fprintf(fid,'      }\n');
                fprintf(fid,'    TrailRGB\n');
                fprintf(fid,'      {\n');
                fprintf(fid,'      R = %d\n',colorList(i,1));
                fprintf(fid,'      G = %d\n',colorList(i,2));
                fprintf(fid,'      B = %d\n',colorList(i,3));
                fprintf(fid,'      }\n');
                fprintf(fid,'    }\n');
            end
            fclose(fid);
        case 'MATLAB'
            [file,path]=uiputfile({'*.m','MATLAB Function (*.m)'},'Export for MATLAB');
            if isequal(file,0),return;end
            name=strtrim(nameField.Value);
            if isempty(name),name='mycolormap';end
            name=matlab.lang.makeValidName(name);
            fid=fopen(fullfile(path,file),'w');
            fprintf(fid,'function cmap = %s(m)\n',name);
            fprintf(fid,'%% %s colormap\n',upper(name));
            fprintf(fid,'anchor = [\n');
            for i=1:size(colorList,1)
                fprintf(fid,'%.4f %.4f %.4f\n',colorList(i,1)/255,colorList(i,2)/255,colorList(i,3)/255);
            end
            fprintf(fid,'];\n');
            fprintf(fid,'if nargin < 1\n');
            fprintf(fid,'    m = size(get(gcf,''colormap''),1);\n');
            fprintf(fid,'end\n');
            fprintf(fid,'cmap = interp1(linspace(0,1,size(anchor,1)),anchor,linspace(0,1,m));\n');
            fprintf(fid,'end\n');
            fclose(fid);
    end
end

% =========================================================================
% 导入colormap文件回调
function importMapCallback(~,~)
    try
        [file,path]=uigetfile({'*.txt;*.pal;*.map;*.m;*.mat','All Colormap Files';...
            '*.txt','COMSOL Colormap (*.txt)';...
            '*.pal','Origin JASC-PAL (*.pal)';...
            '*.map','Tecplot Macro (*.map)';...
            '*.m','MATLAB Function (*.m)';...
            '*.mat','MATLAB MAT-file (*.mat)'},'Import Colormap');
        if isequal(file,0),return;end
        fullpath=fullfile(path,file);
        fmt=detectImportFormat(fullpath);
        switch fmt
            case 'comsol'
                colors=parseCOMSOL(fullpath);
                name='';
            case 'origin'
                colors=parseOrigin(fullpath);
                name='';
            case 'tecplot'
                [colors,name]=parseTecplot(fullpath);
            case 'matlab_func'
                [colors,name]=parseMatlabFunc(fullpath);
            case 'matlab_mat'
                [colors,name]=parseMatlabMat(fullpath);
        end
        if isempty(colors),return;end
        colorList=colors;
        if ~isempty(name)
            nameField.Value=name;
            if strcmp(fmt,'tecplot')
                formatDD.Value='Tecplot';
            elseif strcmp(fmt,'matlab_func')||strcmp(fmt,'matlab_mat')
                formatDD.Value='MATLAB';
            end
        end
        freshColorAtla();
    catch ME
        uialert(atlaFig,ME.message,'Import Error');
    end
end

% 自动检测导入文件格式
function fmt=detectImportFormat(fullpath)
    [~,~,ext]=fileparts(fullpath);
    if strcmpi(ext,'.mat')
        fmt='matlab_mat';
        return;
    end
    fid=fopen(fullpath,'r');
    str='';
    while ~feof(fid)
        line=strtrim(fgetl(fid));
        if isempty(line)||startsWith(line,'%')
            continue;
        end
        str=line;
        break;
    end
    fclose(fid);
    if startsWith(str,'JASC-PAL')
        fmt='origin';
    elseif startsWith(str,'#!MC')
        fmt='tecplot';
    elseif startsWith(str,'function')
        fmt='matlab_func';
    else
        fmt='comsol';
    end
end

% 解析COMSOL .txt
function colors=parseCOMSOL(fullpath)
    fid=fopen(fullpath,'r');
    colors=[];
    while ~feof(fid)
        line=strtrim(fgetl(fid));
        if isempty(line)||startsWith(line,'%')
            continue;
        end
        vals=sscanf(line,'%f');
        if numel(vals)>=3
            colors(end+1,:)=round(vals(1:3)'*255);
        end
    end
    fclose(fid);
    colors=double(colors);
end

% 解析Origin .pal
function colors=parseOrigin(fullpath)
    fid=fopen(fullpath,'r');
    fgetl(fid);fgetl(fid);fgetl(fid);
    colors=[];
    while ~feof(fid)
        line=strtrim(fgetl(fid));
        if isempty(line),continue;end
        vals=sscanf(line,'%d');
        if numel(vals)>=3
            colors(end+1,:)=vals(1:3)';
        end
    end
    fclose(fid);
    colors=double(colors);
end

% 解析Tecplot .map
function [colors,name]=parseTecplot(fullpath)
    fid=fopen(fullpath,'r');
    txt=fread(fid,'*char')';
    fclose(fid);
    name='';
    nameMatch=regexp(txt,'Name\s*=\s*''([^'']*)''','tokens','once');
    if ~isempty(nameMatch),name=nameMatch{1};end
    colors=[];
    blocks=regexp(txt,'LeadRGB\s*\{([^}]*)\}','tokens');
    if isempty(blocks),blocks=regexp(txt,'TrailRGB\s*\{([^}]*)\}','tokens');end
    for i=1:numel(blocks)
        vals=sscanf(blocks{i}{1},'%d');
        if numel(vals)>=3
            colors(end+1,:)=vals(1:3)';
        end
    end
    colors=double(colors);
end

% 解析MATLAB .m函数
function [colors,name]=parseMatlabFunc(fullpath)
    fid=fopen(fullpath,'r');
    txt=fread(fid,'*char')';
    fclose(fid);
    name='';
    nameMatch=regexp(txt,'function\s+\w*\s*=\s*(\w+)','tokens','once');
    if ~isempty(nameMatch),name=nameMatch{1};end
    colors=[];
    anchorMatch=regexp(txt,'anchor\s*=\s*\[([^\]]*)\]','tokens','once');
    if isempty(anchorMatch),return;end
    lines=strsplit(strtrim(anchorMatch{1}),'\n');
    for i=1:numel(lines)
        line=strtrim(lines{i});
        if isempty(line),continue;end
        vals=sscanf(line,'%f');
        if numel(vals)>=3
            colors(end+1,:)=round(vals(1:3)'*255);
        end
    end
    colors=double(colors);
end

% 解析MATLAB .mat
function [colors,name]=parseMatlabMat(fullpath)
    vars=load(fullpath);
    fields=fieldnames(vars);
    colors=[];
    name='';
    for i=1:numel(fields)
        val=vars.(fields{i});
        if isnumeric(val)&&ismatrix(val)&&size(val,2)==3
            colors=double(round(max(0,min(1,val))*255));
            name=fields{i};
            break;
        end
    end
    if isempty(colors)
        error('No Nx3 numeric variable found in .mat file.');
    end
end

end