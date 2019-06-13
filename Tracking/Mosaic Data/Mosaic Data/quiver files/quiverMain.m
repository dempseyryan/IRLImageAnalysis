%this script is the calling function for drawing quiver plots
%(displacement, strain, velocity, acceleration)
close all
%options
show_ims = true;
show_step = 15;
do_disp = true;
% do_strain = false;
% do_vel = false;
do_acc = false;

do_movingimage = false;
do_Lagrangian_Difference = true;

do_tissue_difference=false;


do_ref = true;
do_cur = false;



% select Ncorr data to load:
% load('90cm1.mat');
disp_space = data_dic_save.dispinfo.spacing;
two_step = round(show_step/(disp_space+1));
% two_step = round(show_step/(disp_space+1));
disps = data_dic_save.displacements;
pix_scale = data_dic_save.dispinfo.pixtounits;

arrowscale=0.7; %%% shoudl be between 0.5 and 1, changes colour scheme

firstframe=2;  %%%%set to one by default
frame_count = length(disps);
% frame_count = 10;
im_names = {reference_save.name, current_save.name};
% im_names(1) = 'profused_1k_drop_37cm_00000050b.tif';
x_pix = 651; %%% Size of Image
y_pix = 463;

% DO REFERENCE TYPE?
if do_ref==true
    %roi adjusted for displacement spacing
%     roi = reference_save.roi.mask(1:disp_space+1:end,1:disp_space+1:end);
    %     left_bnd = data_dic_save.displacements(1).roi_ref_formatted.region.leftbound;
    %     right_bnd = data_dic_save.displacements(1).roi_ref_formatted.region.rightbound;
    %     up_bnd = data_dic_save.displacements(1).roi_ref_formatted.region.upperbound;
    %     low_bnd = data_dic_save.displacements(1).roi_ref_formatted.region.lowerbound

    [x_mesh, y_mesh] = meshgrid(1:(disp_space+1)*two_step:x_pix,1:(disp_space+1)*two_step:y_pix);    
        
    im_disp = {};
    im_vel = {};
    im_acc = {};
    im_strain = {};
    num=0;
    
    for frameId = firstframe:frame_count
        % get image dir
        im_ref = reference_save.name;
        
        % Get displacements. (Lagrangian)
        u_ref_disp = disps(frameId).plot_u_ref_formatted(1:two_step:end,1:two_step:end);
        v_ref_disp = disps(frameId).plot_v_ref_formatted(1:two_step:end,1:two_step:end);
             
        % Normalize with a fixed point on the body (trans_x, trans_y, rot)
        % getTransform();
        
        % u_ref_disp_norm = ;
        % v_ref_disp_norm = ;
        
        num=num+1;
        
        % draw displacement quiver (for original files, remove num)
%         im_disp{frameId}=drawQuiver(im_names{1},x_mesh(:),y_mesh(:),u_ref_disp(:),v_ref_disp(:),20,show_step);
    
%         im_disp{frameId}=drawQuiver(im_names{1},x_mesh(:),y_mesh(:),u_ref_disp(:),v_ref_disp(:),20,show_step,num,x_pix,y_pix,arrowscale);
        
        if do_Lagrangian_Difference
             %%%% Lagrangian Difference Calculation, t2-t1
             % Get displacements t=0. (Lagrangian)
             if frameId==1
                u = 0;
                v = 0;
             else
                u_ref_disp0 = disps(frameId-1).plot_u_ref_formatted(1:two_step:end,1:two_step:end);
                v_ref_disp0 = disps(frameId-1).plot_v_ref_formatted(1:two_step:end,1:two_step:end);
                u = u_ref_disp - u_ref_disp0;
                v = v_ref_disp - v_ref_disp0;
             end
             
            im_disp{frameId}=drawQuiver(im_names{1},x_mesh(:),y_mesh(:),u(:),v(:),20,show_step,num,x_pix,y_pix,arrowscale);

        end
        
        if do_movingimage
%             u = disps(frameId).plot_u_cur_formatted(1:two_step:end,1:two_step:end);
%             v = disps(frameId).plot_v_cur_formatted(1:two_step:end,1:two_step:end);
            
%             if do_tissue_difference 
%                 u(1:length(u)/2,:)=0;
%                 v(1:length(u)/2,:)=0;
%                 u(1:length(u)/2,:)=0;
%                 v(1:length(u)/2,:)=0;
%                 for i = Right-25:two_step:x_pix;
%                 end
%                     
%                 u = disps(frameId).plot_u_cur_formatted(Right-25:two_step:end,1:two_step:end)-disps(frameId).plot_u_cur_formatted(Right-Left-25:two_step:Right-Left+25,1:two_step:end);
%                 v = disps(frameId).plot_v_cur_formatted(Right-25:two_step:end,1:two_step:end)-disps(frameId).plot_v_cur_formatted(Right-Left-25:two_step:Right-Left+25,1:two_step:end);
                
%             end
            
            im_disp{frameId}=drawQuiver(im_names{frameId},x_mesh(:),y_mesh(:),u(:),v(:),20,show_step,num,x_pix,y_pix,arrowscale);
        
        end
        
        %%%Draw Quivers
    end
end
        
