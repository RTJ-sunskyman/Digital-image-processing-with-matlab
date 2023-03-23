classdef matFinDIPtest < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                matlab.ui.Figure
        But_CamShot             matlab.ui.control.Button
        But_CamOpen             matlab.ui.control.Button
        But_PicSave             matlab.ui.control.Button
        But_PicOpen             matlab.ui.control.Button
        TabGroup                matlab.ui.container.TabGroup
        Tab                     matlab.ui.container.Tab
        But_DeNoise_midfilt     matlab.ui.control.Button
        Button_12               matlab.ui.control.Button
        Button_11               matlab.ui.control.Button
        Drop_Mirr               matlab.ui.control.DropDown
        Label_10                matlab.ui.control.Label
        But_EnNoise_uniform     matlab.ui.control.Button
        But_EnNoise_saltpepper  matlab.ui.control.Button
        But_EnNoise_gaussian    matlab.ui.control.Button
        Label_9                 matlab.ui.control.Label
        Button_5                matlab.ui.control.Button
        Tab_2                   matlab.ui.container.Tab
        Palette                 matlab.ui.container.Panel
        BSlider                 matlab.ui.control.Slider
        BSliderLabel            matlab.ui.control.Label
        GSlider                 matlab.ui.control.Slider
        GSliderLabel            matlab.ui.control.Label
        RSlider                 matlab.ui.control.Slider
        RSliderLabel            matlab.ui.control.Label
        Slider_saturation       matlab.ui.control.Slider
        Label_5                 matlab.ui.control.Label
        Slider_contrast         matlab.ui.control.Slider
        Label_4                 matlab.ui.control.Label
        Slider_brightness       matlab.ui.control.Slider
        Label_3                 matlab.ui.control.Label
        Tab_3                   matlab.ui.container.Tab
        But_RegionGrow          matlab.ui.control.Button
        ButtonGroup             matlab.ui.container.ButtonGroup
        logButton               matlab.ui.control.RadioButton
        robertsButton           matlab.ui.control.RadioButton
        sobelButton             matlab.ui.control.RadioButton
        But_Threshold           matlab.ui.control.Button
        But_EdgeSharp           matlab.ui.control.Button
        Tab_4                   matlab.ui.container.Tab
        But_AddFrame            matlab.ui.control.Button
        But_Atomization         matlab.ui.control.Button
        Tab_5                   matlab.ui.container.Tab
        Edit_CircularRatio      matlab.ui.control.NumericEditField
        Label_14                matlab.ui.control.Label
        Edit_SquareRatio        matlab.ui.control.NumericEditField
        Label_13                matlab.ui.control.Label
        Edit_C                  matlab.ui.control.NumericEditField
        Label_12                matlab.ui.control.Label
        But_EnsureChoice        matlab.ui.control.Button
        Edit_fliedchoice        matlab.ui.control.NumericEditField
        Label_11                matlab.ui.control.Label
        But_measure             matlab.ui.control.Button
        Label_8                 matlab.ui.control.Label
        ImageAxes               matlab.ui.control.UIAxes
    end


    properties (Access = private)
        mainPic;
        Cam;
        prebr=50;
        presat=0;
        preR=0; preG=0; preB=0;
    end

    methods (Access = private)

        function ShowPic(app)
            imshow(app.mainPic,"Parent",app.ImageAxes);
        end
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: But_PicOpen
        function But_PicOpenPushed(app, event)
            filterspec = {'*.jpg;*.bmp;*.png'};
            [filename, pathname] = uigetfile(filterspec);
            if (ischar(pathname))
                fullname = [pathname filename];
                app.mainPic=imread(fullname);
                imshow(fullname,"Parent",app.ImageAxes);
            end
        end

        % Button pushed function: But_CamOpen
        function But_CamOpenPushed(app, event)
            set(app.But_CamShot,"enable","on");     %激活【截图】键
            app.Cam = videoinput('winvideo',1);     %打开摄像头
            preview(app.Cam);
        end

        % Button pushed function: But_CamShot
        function But_CamShotPushed(app, event)
            app.mainPic=getsnapshot(app.Cam); app.ShowPic;
            delete(app.Cam);
            set(app.But_CamShot,"enable","off");
        end

        % Button pushed function: But_EnNoise_gaussian
        function But_EnNoise_gaussianButtonPushed(app, event)
            app.mainPic=imnoise(app.mainPic,'gaussian',0,0.03);
            app.ShowPic;
        end

        % Button pushed function: But_EnNoise_saltpepper
        function But_EnNoise_saltpepperButtonPushed(app, event)
            app.mainPic=imnoise(app.mainPic,'salt & pepper',0.2);
            app.ShowPic;
        end

        % Button pushed function: But_EnNoise_uniform
        function But_EnNoise_uniformButtonPushed(app, event)
            app.mainPic=imnoise(app.mainPic,"speckle",0.04);
            app.ShowPic;
        end

        % Button pushed function: But_DeNoise_midfilt
        function But_DeNoise_midfiltPushed(app, event)
            function d=midfilt(x, n)
                [M,N]=size(x);
                x1=x;
                x2=x1;
                for i=1:M-n+1
                    for j=1:N-n+1
                        c=x1(i:i+n-1,j:j+n-1);
                        e=c(1,:);
                        for k=2:n
                            e=[e,c(k,:)];
                        end
                        x2(i+(n-1)/2,j+(n-1)/2)=median(e);
                    end
                end
                d=x2;
            end
            app.mainPic=midfilt(app.mainPic,3);
            app.ShowPic;
        end

        % Value changed function: Drop_Mirr
        function Drop_MirrValueChanged(app, event)
            value = app.Drop_Mirr.Value;
            tform = affine2d([1 0 0; 0 1 0; 0 0 1]);
            switch value
                case "原点对称"
                    tform = affine2d([-1 0 0; 0 -1 0; 0 0 1]);
                case "x轴对称"
                    tform = affine2d([1 0 0; 0 -1 0; 0 0 1]);
                case "y轴对称"
                    tform = affine2d([-1 0 0; 0 1 0; 0 0 1]);
                case "y=x对称"
                    %不知道，有时间再想
                case "y=-x对称"
                    %不知道，有时间再想
            end
            app.mainPic = imwarp(app.mainPic,tform);
            app.ShowPic;
        end

        % Button pushed function: Button_5
        function Button_5Pushed(app, event)
            rect=[0 0 100 100];
            app.mainPic = imcrop(app.mainPic,rect);
            app.ShowPic;
        end

        % Button pushed function: Button_11
        function Button_11Pushed(app, event)
            app.mainPic = imrotate(app.mainPic,-90);
            app.ShowPic;
        end

        % Button pushed function: Button_12
        function Button_12Pushed(app, event)
            app.mainPic = imtranslate(app.mainPic,[100 0]);
            app.ShowPic;
        end

        % Value changing function: Slider_brightness
        function Slider_brightnessValueChanging(app, event)
            change=event.Value-app.prebr;
            app.mainPic=imadd(app.mainPic,change);
            app.ShowPic;
            app.prebr=event.Value;
        end

        % Value changing function: Slider_contrast
        function Slider_contrastValueChanging(app, event)
            curcont=event.Value;
            if curcont==0.5
                curcont=0.49;
            end
            app.mainPic=imadjust(app.mainPic,[curcont, 1-curcont],[]);
            app.ShowPic;
        end

        % Value changing function: Slider_saturation
        function Slider_saturationValueChanging(app, event)
            change=event.Value-app.presat;
            function Image_new = SaturationAdjustment(src,saturation)
                Image=double(src);
                R=Image(:,:,1);
                G=Image(:,:,2);
                B=Image(:,:,3);
                [row, col] = size(R);
                R_new=R; G_new=G; B_new=B;
                %%%% Increment, 饱和度调整增量（-100,100）photoshop的范围
                Increment=saturation/100;

                %利用HSL模式求得颜色的S和L
                for i=1:row
                    for j=1:col
                        rgbMax=max(R(i,j),max(G(i,j),B(i,j)));
                        rgbMin=min(R(i,j),min(G(i,j),B(i,j)));
                        Delta=(rgbMax-rgbMin)/255;
                        if(Delta==0), continue; end %如果delta=0，则饱和度S=0，所以不能调整饱和度
                        value=(rgbMax+rgbMin)/255;
                        L=value/2;                  %Lightness
                        if(L<0.5), S=Delta/value;   %根据明度L计算饱和度S
                        else, S=Delta/(2-value); end
                        %具体的饱和度调整，Increment为饱和度增减量
                        if (Increment>=0)
                            if((Increment+S)>=1), alpha=S;
                            else, alpha=1-Increment; end
                            alpha=1/alpha-1;
                            R_new(i,j) = R(i,j) + (R(i,j) - L * 255) * alpha;
                            G_new(i,j) = G(i,j) + (G(i,j) - L * 255) * alpha;
                            B_new(i,j) = B(i,j) + (B(i,j) - L * 255) * alpha;
                        else
                            alpha=Increment;
                            R_new(i,j) = L*255 + (R(i,j) - L * 255) * (1+alpha);
                            G_new(i,j) = L*255 + (G(i,j) - L * 255) * (1+alpha);
                            B_new(i,j) = L*255 + (B(i,j) - L * 255) * (1+alpha);
                        end
                    end
                end
                Image_new(:,:,1)=R_new;
                Image_new(:,:,2)=G_new;
                Image_new(:,:,3)=B_new;
            end
            app.mainPic=SaturationAdjustment(app.mainPic,change);
            imshow(app.mainPic/255,"Parent",app.ImageAxes);
            app.presat=event.Value;
        end

        % Value changing function: RSlider
        function RSliderValueChanging(app, event)
            changeR=event.Value-app.preR;
            app.mainPic(:,:,1)=app.mainPic(:,:,1)+changeR;
            app.ShowPic;
            app.preR=event.Value;
        end

        % Value changing function: GSlider
        function GSliderValueChanging(app, event)
            changeG=event.Value-app.preG;
            app.mainPic(:,:,2)=app.mainPic(:,:,2)+changeG;
            app.ShowPic;
            app.preG=event.Value;
        end

        % Value changing function: BSlider
        function BSliderValueChanging(app, event)
            changeB=event.Value-app.preB;
            app.mainPic(:,:,3)=app.mainPic(:,:,3)+changeB;
            app.ShowPic;
            app.preB=event.Value;
        end

        % Button pushed function: But_EdgeSharp
        function But_EdgeSharpButtonPushed(app, event)
            img = rgb2gray(app.mainPic);
            %%进行3*3均值滤波
            a_bmp = filter2(fspecial('average',3),img)/255;
            %%边缘提取
            switch app.ButtonGroup.SelectedObject.Text
                case "sobel算子"
                    app.mainPic = edge(a_bmp,'sobel');
                case "roberts算子"
                    app.mainPic = edge(a_bmp,'roberts');
                case "log算子"
                    app.mainPic = edge(a_bmp,'log');
            end
            app.ShowPic;
        end

        % Button pushed function: But_Threshold
        function But_ThresholdPushed(app, event)
            grayImg=rgb2gray(app.mainPic);  %对图像灰度化
            T=mean2(grayImg);               %对图像三通道求均值
            count=0;
            d=T;
            while d>0.5
                count=count+1;
                g=grayImg>T;
                T1=0.5*(mean2(grayImg(g))+mean2(grayImg(~g)));
                d=abs(T1-T);
                T=T1;
            end
            app.mainPic=im2bw(grayImg,T/255);
            app.ShowPic;
        end

        % Button pushed function: But_RegionGrow
        function But_RegionGrowPushed(app, event)
            figure; imshow(app.mainPic);
            tmp=ginput(1);
            tmp(1,2)=512-tmp(1,2);
            seeds=round(tmp);
            close;

            img=app.mainPic;
            ycc=double(rgb2ycbcr(img));
            img=double(img);

            marker=zeros(size(img,1),size(img,2));
            for i=1:size(seeds,1)
                marker(seeds(i,1),seeds(i,2))=1;
            end

            thresh=[50 30 27];
            maskMax=zeros(size(img,1),size(img,2));
            for i=1:size(seeds,1)
                absDiff=abs(ycc-ycc(seeds(i,1),seeds(i,2),:));
                g=absDiff(:,:,1)<thresh(1) & absDiff(:,:,2)<thresh(2) & absDiff(:,:,3)<thresh(3);
                maskMax=maskMax|g;
            end

            maskMax=double(maskMax);
            maskR=imreconstruct(marker,maskMax);
            mask=cat(3,maskR,maskR,maskR);
            app.mainPic=uint8(mask.*img);
            app.ShowPic;
        end

        % Button pushed function: But_AddFrame
        function But_AddFrameButtonPushed(app, event)
            frame=imread("边框.png");
            app.mainPic=imadd(app.mainPic,frame);
            app.ShowPic;
        end

        % Button pushed function: But_Atomization
        function But_AtomizationButtonPushed(app, event)
            oldImg=app.mainPic;
            [m,n,~]=size(oldImg);
            r=oldImg(:,:,1); g=oldImg(:,:,2); b=oldImg(:,:,3);
            for i=2:m-10
                for j=2:n-10
                    k=rand(1)*10;           %产生一个随机数作为半径
                    di=i+round(mod(k,33));  %得到随机横坐标
                    dj=j+round(mod(k,33));  %得到随机纵坐标
                    %将原像素点用随机像素点代替
                    r(i,j)=r(di,dj);
                    g(i,j)=g(di,dj);
                    b(i,j)=b(di,dj);
                end
            end
            oldImg(:,:,1)=r;
            oldImg(:,:,2)=g;
            oldImg(:,:,3)=b;
            app.mainPic=oldImg;
            app.ShowPic;
        end

        % Button pushed function: But_PicSave
        function But_PicSaveButtonPushed(app, event)
            filterspec={'*.jpg;*.bmp;*.png'};
            [FileName, PathName]=uiputfile(filterspec,'Save Picture','Untitled');
            if (ischar(PathName))
                fullname = [PathName FileName];
                imwrite(app.mainPic,fullname);
            end
        end

        % Button pushed function: But_measure
        function But_measureButtonPushed(app, event)
            img=app.mainPic; %读取原图像
            grayimg = rgb2gray(img);
            BWimg = grayimg;
            [width,height]=size(grayimg);
            %二值化
            T1=80;
            for i=1:width
                for j=1:height
                    if(grayimg(i,j)<T1)
                        BWimg(i,j)= 255;
                    else
                        BWimg(i,j)= 0;
                    end
                end
            end

            %先闭运算 再开运算
            se=strel('disk',5);
            BWimg = imclose(BWimg,se);
            BWimg = imopen(BWimg,se);

            %使用外接矩形框选连通域，并使用形心确定连通域位置
            [mark_image,num] = bwlabel(BWimg,4);
            status=regionprops(mark_image,'BoundingBox');
            centroid = regionprops(mark_image,'Centroid');
            app.mainPic=mark_image;
            app.ShowPic;

            for i=1:num
                rectangle(app.ImageAxes,'position',status(i).BoundingBox,'edgecolor','r');
                text(app.ImageAxes,centroid(i,1).Centroid(1,1)-15, ...
                    centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r')
            end

        end

        % Button pushed function: But_EnsureChoice
        function But_EnsureChoiceButtonPushed(app, event)
            copy_mark_image = app.mainPic;
            image_part = (copy_mark_image == app.Edit_fliedchoice.Value);
            % image_part3 = (mark_image ~= 3);
            figure;
            imshow(image_part);

            %求周长
            girth = regionprops(image_part,'Perimeter');
            app.Edit_C.Value=girth.Perimeter;
            
            %求矩形度
            round_area = regionprops(image_part,'Area');
            S=round_area.Area;     %自身面积
            BoundingBox=regionprops(image_part,'BoundingBox');
            width=BoundingBox.BoundingBox(3);
            height=BoundingBox.BoundingBox(4);
            S2=width*height;        %最小外接矩形框面积
            app.Edit_SquareRatio.Value=S/S2;
            
            %求圆形度 e=（4π*面积）/（周长*周长）
            C=girth.Perimeter;
            app.Edit_CircularRatio.Value=(4*3.14*S)/(C*C);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 770 448];
            app.UIFigure.Name = 'MATLAB App';

            % Create ImageAxes
            app.ImageAxes = uiaxes(app.UIFigure);
            app.ImageAxes.Toolbar.Visible = 'off';
            app.ImageAxes.XTick = [];
            app.ImageAxes.XTickLabel = {'[ ]'};
            app.ImageAxes.YTick = [];
            app.ImageAxes.Position = [30 111 256 256];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [312 33 428 384];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = '预处理';

            % Create Button_5
            app.Button_5 = uibutton(app.Tab, 'push');
            app.Button_5.ButtonPushedFcn = createCallbackFcn(app, @Button_5Pushed, true);
            app.Button_5.Position = [49 146 100 26];
            app.Button_5.Text = '裁剪';

            % Create Label_9
            app.Label_9 = uilabel(app.Tab);
            app.Label_9.Position = [57 305 29 22];
            app.Label_9.Text = '加噪';

            % Create But_EnNoise_gaussian
            app.But_EnNoise_gaussian = uibutton(app.Tab, 'push');
            app.But_EnNoise_gaussian.ButtonPushedFcn = createCallbackFcn(app, @But_EnNoise_gaussianButtonPushed, true);
            app.But_EnNoise_gaussian.Position = [118 304 72 25];
            app.But_EnNoise_gaussian.Text = '高斯噪声';

            % Create But_EnNoise_saltpepper
            app.But_EnNoise_saltpepper = uibutton(app.Tab, 'push');
            app.But_EnNoise_saltpepper.ButtonPushedFcn = createCallbackFcn(app, @But_EnNoise_saltpepperButtonPushed, true);
            app.But_EnNoise_saltpepper.Position = [202 304 72 26];
            app.But_EnNoise_saltpepper.Text = '椒盐噪声';

            % Create But_EnNoise_uniform
            app.But_EnNoise_uniform = uibutton(app.Tab, 'push');
            app.But_EnNoise_uniform.ButtonPushedFcn = createCallbackFcn(app, @But_EnNoise_uniformButtonPushed, true);
            app.But_EnNoise_uniform.Position = [283 303 87 26];
            app.But_EnNoise_uniform.Text = '均匀随机噪声';

            % Create Label_10
            app.Label_10 = uilabel(app.Tab);
            app.Label_10.HorizontalAlignment = 'right';
            app.Label_10.Position = [49 188 53 22];
            app.Label_10.Text = '对称变换';

            % Create Drop_Mirr
            app.Drop_Mirr = uidropdown(app.Tab);
            app.Drop_Mirr.Items = {'原点对称', 'x轴对称', 'y轴对称', 'y=x对称', 'y=-x对称', '点击选择对称类型'};
            app.Drop_Mirr.ValueChangedFcn = createCallbackFcn(app, @Drop_MirrValueChanged, true);
            app.Drop_Mirr.Position = [117 188 131 22];
            app.Drop_Mirr.Value = '点击选择对称类型';

            % Create Button_11
            app.Button_11 = uibutton(app.Tab, 'push');
            app.Button_11.ButtonPushedFcn = createCallbackFcn(app, @Button_11Pushed, true);
            app.Button_11.Position = [158 145 100 27];
            app.Button_11.Text = '旋转';

            % Create Button_12
            app.Button_12 = uibutton(app.Tab, 'push');
            app.Button_12.ButtonPushedFcn = createCallbackFcn(app, @Button_12Pushed, true);
            app.Button_12.Position = [267 144 100 25];
            app.Button_12.Text = '平移';

            % Create But_DeNoise_midfilt
            app.But_DeNoise_midfilt = uibutton(app.Tab, 'push');
            app.But_DeNoise_midfilt.ButtonPushedFcn = createCallbackFcn(app, @But_DeNoise_midfiltPushed, true);
            app.But_DeNoise_midfilt.Position = [46 257 100 25];
            app.But_DeNoise_midfilt.Text = '去噪';

            % Create Tab_2
            app.Tab_2 = uitab(app.TabGroup);
            app.Tab_2.Title = '图片增强';

            % Create Label_3
            app.Label_3 = uilabel(app.Tab_2);
            app.Label_3.HorizontalAlignment = 'right';
            app.Label_3.Position = [46 321 29 22];
            app.Label_3.Text = '亮度';

            % Create Slider_brightness
            app.Slider_brightness = uislider(app.Tab_2);
            app.Slider_brightness.ValueChangingFcn = createCallbackFcn(app, @Slider_brightnessValueChanging, true);
            app.Slider_brightness.Position = [96 330 249 3];
            app.Slider_brightness.Value = 50;

            % Create Label_4
            app.Label_4 = uilabel(app.Tab_2);
            app.Label_4.HorizontalAlignment = 'right';
            app.Label_4.Position = [46 269 41 22];
            app.Label_4.Text = '对比度';

            % Create Slider_contrast
            app.Slider_contrast = uislider(app.Tab_2);
            app.Slider_contrast.Limits = [0 0.5];
            app.Slider_contrast.ValueChangingFcn = createCallbackFcn(app, @Slider_contrastValueChanging, true);
            app.Slider_contrast.Position = [108 278 150 3];

            % Create Label_5
            app.Label_5 = uilabel(app.Tab_2);
            app.Label_5.HorizontalAlignment = 'right';
            app.Label_5.Position = [46 217 41 22];
            app.Label_5.Text = '饱和度';

            % Create Slider_saturation
            app.Slider_saturation = uislider(app.Tab_2);
            app.Slider_saturation.Limits = [-100 100];
            app.Slider_saturation.ValueChangingFcn = createCallbackFcn(app, @Slider_saturationValueChanging, true);
            app.Slider_saturation.Position = [103 222 229 3];

            % Create Palette
            app.Palette = uipanel(app.Tab_2);
            app.Palette.Title = '调色板';
            app.Palette.Position = [49 12 307 170];

            % Create RSliderLabel
            app.RSliderLabel = uilabel(app.Palette);
            app.RSliderLabel.Position = [35 4 25 22];
            app.RSliderLabel.Text = 'R';

            % Create RSlider
            app.RSlider = uislider(app.Palette);
            app.RSlider.Limits = [0 255];
            app.RSlider.Orientation = 'vertical';
            app.RSlider.ValueChangingFcn = createCallbackFcn(app, @RSliderValueChanging, true);
            app.RSlider.Position = [29 33 3 99];

            % Create GSliderLabel
            app.GSliderLabel = uilabel(app.Palette);
            app.GSliderLabel.Position = [116 4 25 22];
            app.GSliderLabel.Text = 'G';

            % Create GSlider
            app.GSlider = uislider(app.Palette);
            app.GSlider.Limits = [0 255];
            app.GSlider.Orientation = 'vertical';
            app.GSlider.ValueChangingFcn = createCallbackFcn(app, @GSliderValueChanging, true);
            app.GSlider.Position = [111 33 3 99];

            % Create BSliderLabel
            app.BSliderLabel = uilabel(app.Palette);
            app.BSliderLabel.Position = [208 4 25 22];
            app.BSliderLabel.Text = 'B';

            % Create BSlider
            app.BSlider = uislider(app.Palette);
            app.BSlider.Limits = [0 255];
            app.BSlider.Orientation = 'vertical';
            app.BSlider.ValueChangingFcn = createCallbackFcn(app, @BSliderValueChanging, true);
            app.BSlider.Position = [195 33 3 99];

            % Create Tab_3
            app.Tab_3 = uitab(app.TabGroup);
            app.Tab_3.Title = '图像分割';

            % Create But_EdgeSharp
            app.But_EdgeSharp = uibutton(app.Tab_3, 'push');
            app.But_EdgeSharp.ButtonPushedFcn = createCallbackFcn(app, @But_EdgeSharpButtonPushed, true);
            app.But_EdgeSharp.Position = [32 309 100 25];
            app.But_EdgeSharp.Text = '边缘锐化并描边';

            % Create But_Threshold
            app.But_Threshold = uibutton(app.Tab_3, 'push');
            app.But_Threshold.ButtonPushedFcn = createCallbackFcn(app, @But_ThresholdPushed, true);
            app.But_Threshold.Position = [32 143 111 26];
            app.But_Threshold.Text = '阈值分割';

            % Create ButtonGroup
            app.ButtonGroup = uibuttongroup(app.Tab_3);
            app.ButtonGroup.Title = '选择算子';
            app.ButtonGroup.Position = [155 224 123 110];

            % Create sobelButton
            app.sobelButton = uiradiobutton(app.ButtonGroup);
            app.sobelButton.Text = 'sobel算子';
            app.sobelButton.Position = [11 62 75 22];
            app.sobelButton.Value = true;

            % Create robertsButton
            app.robertsButton = uiradiobutton(app.ButtonGroup);
            app.robertsButton.Text = 'roberts算子';
            app.robertsButton.Position = [11 40 83 22];

            % Create logButton
            app.logButton = uiradiobutton(app.ButtonGroup);
            app.logButton.Text = 'log算子';
            app.logButton.Position = [11 18 65 22];

            % Create But_RegionGrow
            app.But_RegionGrow = uibutton(app.Tab_3, 'push');
            app.But_RegionGrow.ButtonPushedFcn = createCallbackFcn(app, @But_RegionGrowPushed, true);
            app.But_RegionGrow.Position = [167 142 100 27];
            app.But_RegionGrow.Text = '区域生长';

            % Create Tab_4
            app.Tab_4 = uitab(app.TabGroup);
            app.Tab_4.Title = '特殊美化';

            % Create But_Atomization
            app.But_Atomization = uibutton(app.Tab_4, 'push');
            app.But_Atomization.ButtonPushedFcn = createCallbackFcn(app, @But_AtomizationButtonPushed, true);
            app.But_Atomization.Position = [118 187 100 25];
            app.But_Atomization.Text = '雾化';

            % Create But_AddFrame
            app.But_AddFrame = uibutton(app.Tab_4, 'push');
            app.But_AddFrame.ButtonPushedFcn = createCallbackFcn(app, @But_AddFrameButtonPushed, true);
            app.But_AddFrame.Position = [118 257 100 25];
            app.But_AddFrame.Text = '加框';

            % Create Tab_5
            app.Tab_5 = uitab(app.TabGroup);
            app.Tab_5.Title = '区域描测';

            % Create Label_8
            app.Label_8 = uilabel(app.Tab_5);
            app.Label_8.Position = [202 234 125 22];
            app.Label_8.Text = '重心即数字标号所在处';

            % Create But_measure
            app.But_measure = uibutton(app.Tab_5, 'push');
            app.But_measure.ButtonPushedFcn = createCallbackFcn(app, @But_measureButtonPushed, true);
            app.But_measure.Position = [73 233 100 25];
            app.But_measure.Text = '进行测量';

            % Create Label_11
            app.Label_11 = uilabel(app.Tab_5);
            app.Label_11.HorizontalAlignment = 'right';
            app.Label_11.Position = [76 171 53 22];
            app.Label_11.Text = '选择区域';

            % Create Edit_fliedchoice
            app.Edit_fliedchoice = uieditfield(app.Tab_5, 'numeric');
            app.Edit_fliedchoice.Position = [144 171 100 22];
            app.Edit_fliedchoice.Value = 1;

            % Create But_EnsureChoice
            app.But_EnsureChoice = uibutton(app.Tab_5, 'push');
            app.But_EnsureChoice.ButtonPushedFcn = createCallbackFcn(app, @But_EnsureChoiceButtonPushed, true);
            app.But_EnsureChoice.Position = [265 168 100 25];
            app.But_EnsureChoice.Text = '确定';

            % Create Label_12
            app.Label_12 = uilabel(app.Tab_5);
            app.Label_12.HorizontalAlignment = 'right';
            app.Label_12.Position = [101 122 29 22];
            app.Label_12.Text = '周长';

            % Create Edit_C
            app.Edit_C = uieditfield(app.Tab_5, 'numeric');
            app.Edit_C.Position = [145 122 100 22];

            % Create Label_13
            app.Label_13 = uilabel(app.Tab_5);
            app.Label_13.HorizontalAlignment = 'right';
            app.Label_13.Position = [89 73 41 22];
            app.Label_13.Text = '矩形度';

            % Create Edit_SquareRatio
            app.Edit_SquareRatio = uieditfield(app.Tab_5, 'numeric');
            app.Edit_SquareRatio.Position = [145 73 100 22];

            % Create Label_14
            app.Label_14 = uilabel(app.Tab_5);
            app.Label_14.HorizontalAlignment = 'right';
            app.Label_14.Position = [88 24 41 22];
            app.Label_14.Text = '圆形度';

            % Create Edit_CircularRatio
            app.Edit_CircularRatio = uieditfield(app.Tab_5, 'numeric');
            app.Edit_CircularRatio.Position = [144 24 100 22];

            % Create But_PicOpen
            app.But_PicOpen = uibutton(app.UIFigure, 'push');
            app.But_PicOpen.ButtonPushedFcn = createCallbackFcn(app, @But_PicOpenPushed, true);
            app.But_PicOpen.Position = [38 70 82 25];
            app.But_PicOpen.Text = '打开图片';

            % Create But_PicSave
            app.But_PicSave = uibutton(app.UIFigure, 'push');
            app.But_PicSave.ButtonPushedFcn = createCallbackFcn(app, @But_PicSaveButtonPushed, true);
            app.But_PicSave.Position = [204 70 82 25];
            app.But_PicSave.Text = '保存图片';

            % Create But_CamOpen
            app.But_CamOpen = uibutton(app.UIFigure, 'push');
            app.But_CamOpen.ButtonPushedFcn = createCallbackFcn(app, @But_CamOpenPushed, true);
            app.But_CamOpen.Position = [38 33 100 25];
            app.But_CamOpen.Text = '打开摄像头';

            % Create But_CamShot
            app.But_CamShot = uibutton(app.UIFigure, 'push');
            app.But_CamShot.ButtonPushedFcn = createCallbackFcn(app, @But_CamShotPushed, true);
            app.But_CamShot.Enable = 'off';
            app.But_CamShot.Position = [146 34 51 25];
            app.But_CamShot.Text = '截图';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = matFinDIPtest

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end