function Img_3D = MY_clustering_function_map_Fus(Img_3D,cluster_size)

% min_thres = binar_thres(1);
% max_thres = binar_thres(2);
min_thres = -0.001;
max_thres = 0.001;
map_sec = Img_3D;
map_sec(map_sec > max_thres) = 1;
map_sec(map_sec < min_thres) = 1;
map_sec(map_sec ~=1) = 0;
CC = bwconncomp(map_sec,8);      % find connected component ²ÎÕÕspmÄ¬ÈÏÖµ18
area = cellfun(@numel, CC.PixelIdxList);  % find concrete pixel index
idxToKeep = CC.PixelIdxList(area >= cluster_size);  % get the indexs of cluster pixels
idxToKeep = vertcat(idxToKeep{:});  % house these indexs
map_sec2 = false(size(map_sec));
map_sec2(idxToKeep) = true;   % mask the cluster
Img_3D = Img_3D.*map_sec2;

end