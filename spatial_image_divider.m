function [image_feats] = spatial_image_divider(img,colour)
% img is the image

% colour is either grayscale or rgb

step_size = 3; %Possible values
bin_size = 2;

switch lower(colour)
    
    case 'grayscale'
        image_feats = [];
        
        [img_div{1}, img_div{2}, img_div{3}, img_div{4}] = image_divider(img, colour);

        for j = 1:4
            [~, SIFT_features{j}] = vl_dsift(img_div{j},'fast','Size',bin_size,'Step',step_size); 
        end

        for i=1:4
           image_feats = [image_feats, SIFT_features{i}];
        end
        
    case 'rgb'
        image_feats = [];
        
        [img_div{1}, img_div{2}, img_div{3}, img_div{4}] = image_divider(img, colour);
        
        for j = 1:4
            [~, SIFT_features{j}] = vl_phow(img_div{j},'fast','True','step',step_size,'sizes',bin_size,'color', colour);
        end

        for i=1:4
           image_feats = [image_feats, SIFT_features{i}];
        end
        
end    
end

