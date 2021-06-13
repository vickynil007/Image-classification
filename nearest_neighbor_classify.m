
function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)

k = 10; % 3 5 7 9 

size_test_image_feat = size(test_image_feats,1);

dist = vl_alldist2(train_image_feats', test_image_feats');

known_labels = unique(train_labels);

size_known_labels = size(known_labels, 1);

count_labels = zeros(size_known_labels, size_test_image_feat);

[~, indices] = sort(dist, 1);

for ii = 1:size_test_image_feat
    for jj = 1: size_known_labels
        highest_k_labels = train_labels(indices(1:k, ii));
        count(jj,ii) = sum(strcmp(known_labels(jj), highest_k_labels));
    end   
end

[~, final_label_index] = max(count,[],1);

predicted_categories = known_labels(final_label_index);

end


