function [image_feats] = get_spatial_pyramids(image_paths, k, colour)
% image_paths is an N x 1 cell array of strings where each string is an
% image path on the file system.

% k is ksearch size

% colour is either grayscale or rgb

% This function assumes that 'vocab.mat' exists and contains an N x 128
% matrix 'vocab' where each row is a kmeans centroid or a visual word. This
% matrix is saved to disk rather than passed in a parameter to avoid
% recomputing the vocabulary every time at significant expense.

% image_feats is an N x d matrix, where d is the dimensionality of the
% feature representation. In this case, d will equal the number of clusters
% or equivalently the number of entries in each image's histogram.

load('vocab_spatial.mat');

vocab_size = size(vocab_spatial, 1); 

step_size = 3; %Possible values
bin_size = 2;

switch lower(colour)
    
    case 'grayscale'
        for i=1:size(image_paths,1)
            total_features = [];

            img = imread(image_paths{i});
            
            %Divides the image
            [img_div{1}, img_div{2}, img_div{3}, img_div{4}] = image_divider(img, colour);
            img = single(rgb2gray(img));
            
            for p=1:4
                SIFT_features{p} = spatial_image_divider(img_div{p}, colour);
            end
            
            SIFT_features{5} = spatial_image_divider(img, colour);
            
            [~, SIFT_features{6}] = vl_dsift(img,'fast','Size',bin_size,'Step',step_size);

            for j=1:6
               total_features =  [total_features, SIFT_features{j}];
            end
            
            total_features = single(total_features);
            
            [cluster_num, ~] = knnsearch(vocab_spatial', total_features', 'k', k);
            
            [image_feats(i,:), ~] = histcounts(cluster_num, vocab_size);
            
            image_feats(i,:) = rescale(image_feats(i,:));
        end
        
    case 'rgb'
        
        for i=1:size(image_paths,1)          
            total_features = [];

            img = imread(image_paths{i});

            %Divides the image
            [img_div{1}, img_div{2}, img_div{3}, img_div{4}] = image_divider(img, colour);
            img = single(img);
            
            for p=1:4
                SIFT_features{p} = spatial_image_divider(img_div{p}, colour);
            end
            
            SIFT_features{5} = spatial_image_divider(img, colour);

            [~, SIFT_features{6}] = vl_phow(img,'fast','True','step',step_size,'sizes',bin_size,'color', colour);

            for j=1:6
               total_features =  [total_features, SIFT_features{j}];
            end
            
            total_features = single(total_features);
            
            [cluster_num, ~] = knnsearch(vocab_spatial', total_features', 'k', k);
            
            [image_feats(i,:), ~] = histcounts(cluster_num, vocab_size);
            
            image_feats(i,:) = rescale(image_feats(i,:));
        end
        
end

end

