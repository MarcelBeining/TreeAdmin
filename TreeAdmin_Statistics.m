function TreeAdmin_Statistics(treegroups,treenames)

global stats
sholl_diam = 25;
use = 1:numel(treegroups);


figure
stats = stats_tree(treegroups,treenames,[],'-w-x-s');
max_radg = 300;

for u = 1:numel(use)
    for i = 1:numel(treegroups{u})
        stats.dstats(u).angleBB{i} = angleBB_tree(treegroups{u}{i});
        stats.gstats(u).mangleBB(i)= mean(stats.dstats(u).angleBB{i}(~isnan(stats.dstats(u).angleBB{i})));
        stats.dstats(u).sholl{i} = sholl_tree(treegroups{u}{i},sholl_diam);
        %     stats.names{i} = trees{i}.name;
        [stats.gstats(u).maxsholl(i),stats.gstats(u).maxshollrad(i)] = max(stats.dstats(u).sholl{i});
        %     max_rad = max(max_rad,numel(stats.dstats(1).sholl{i}));
    end
    stats.gstats(u).maxshollrad = (stats.gstats(u).maxshollrad -1)*sholl_diam/2;  % make ind to sholl radius
end
%%

figure(3)
subplot(3,2,1)
hold on
col = {'b','r','g','y'};
col = col(1:numel(use));
maxlen=0;

for i = 1:numel(use)
    usethis = use(i);
    data=[];
    for u = 1:numel(stats.dstats(usethis).sholl)
        plot(0:25:25*(numel(stats.dstats(usethis).sholl{u})-1),stats.dstats(usethis).sholl{u},col{i})
        [nix,ind]=max(stats.dstats(usethis).sholl{u});
        h=plot(mean(ind-1)*25,nix,sprintf('%so',col{i}));
        set(h,{'MarkerSize','LineWidth'},{5+usethis*3,2})
        data = cat(1,data,mean(ind-1));
    end

    plot([mean(data)-std(data) mean(data)+std(data)]*25,[1+0.1^i 1+0.1^i],sprintf('%s-',col{i}))
        plot(mean(data)*25,1+0.1^i,sprintf('%s.',col{i}))
        maxlen = max(maxlen,max(stats.gstats(usethis).len));
end
title('Sholl Distribution','FontSize',12,'FontWeight','bold')
xlabel('Diameter [µm]')
ylabel('Intersections')

subplot(3,2,2)
nb=[];
for i = 1:numel(treegroups)
    [nb(:,i),xb] = hist(stats.gstats(i).len,0:ceil(maxlen/1000)*100:maxlen);
end
nb = nb./repmat(sum(nb),[size(nb,1),1])*100;

h = bar(xb,nb);
set(h(2),'FaceColor','r')
title('Total Cable Length [µm]','FontSize',12,'FontWeight','bold')
ylabel('[%]')

subplot(3,2,3)
hold on
euclall = cell(2,1);
angall = cell(2,1);
for i=1:numel(treegroups)
    for o=1:numel(treegroups{i})
        eucl = eucl_tree(treegroups{i}{o});
        euclall{i} = cat(1,euclall{i},eucl(B_tree(treegroups{i}{o})));
        ang = rad2deg(angleBB_tree(treegroups{i}{o}));
        angall{i} = cat(1,angall{i},ang(B_tree(treegroups{i}{o})));
    end
    plot(euclall{i},angall{i},sprintf('%s.',col{i}));
end
xlabel('distance from soma [µm]')
ylabel('segment angle [°]')
legend(treenames)


subplot(3,2,4)
nb=[];
for i = 1:numel(treegroups)
    [nb(:,i),xb] = hist(rad2deg(stats.gstats(i).mangleBB),0:10:150);
end
nb = nb./repmat(sum(nb),[size(nb,1),1])*100;
h = bar(xb,nb);
set(h(2),'FaceColor','r')
title('Mean Segment Angle [°]','FontSize',12,'FontWeight','bold')
set(gca,'XLim',[0 100])
ylabel('[%]')

subplot(3,2,5)
hold on
euclall = cell(2,1);
angall = cell(2,1);
for i=1:numel(treegroups)
    for o=1:numel(treegroups{i})
        eucl = eucl_tree(treegroups{i}{o});
        euclall{i} = cat(1,euclall{i},eucl(B_tree(treegroups{i}{o})));
        ang = rad2deg(angleB_tree(treegroups{i}{o}));
        angall{i} = cat(1,angall{i},ang(B_tree(treegroups{i}{o})));
    end
    plot(euclall{i},angall{i},sprintf('%s.',col{i}));
end
xlabel('distance from soma [µm]')
ylabel('branching angle [°]')
legend(treenames)


subplot(3,2,6)
nb=[];
for i = 1:numel(treegroups)
    [nb(:,i),xb] = hist(rad2deg(stats.gstats(i).mangleB),0:10:150);
end
nb = nb./repmat(sum(nb),[size(nb,1),1])*100;
h = bar(xb,nb);
set(h(2),'FaceColor','r')
title('Mean Branchpoint Angle [°]','FontSize',12,'FontWeight','bold')
set(gca,'XLim',[0 100])
ylabel('[%]')

%%
if numel(unique(cellfun(@numel,treegroups))) == 1
    figure(2)
    subplot(3,4,1)
    hist(cat(1,stats.gstats.maxsholl)',1:20)
    title('Maximum Sholl Intersections')
    xlabel('Diameter [µm]')
    legend(stats.s)
    
    subplot(3,4,2)
    hist(cat(1,stats.gstats.maxshollrad)',sholl_diam/2:sholl_diam/2:max_radg)
    title('Distances of Maximum Sholl Intersection')
    set(gca,'XLim',[0 max_radg])
    set(gca,'XTick',0:50:max_radg)
    
    subplot(3,4,3)
    hist(cat(2,stats.gstats.maxbo),1:10)
    title('Maximum Branching Order')
    set(gca,'XLim',[1 10])
    
    subplot(3,4,4)
    hist(cat(2,stats.gstats.mbo),1:10)
    title('Mean Branching Order')
    set(gca,'XLim',[1 10])
    
    subplot(3,4,5)
    hist(cat(2,rad2deg(cat(2,stats.gstats.mangleB))),0:10:150)
    title('Mean Angle [°]')
    set(gca,'XLim',[0 100])
    
    
    subplot(3,4,6)
    hist(cat(2,cat(2,stats.gstats.len)))
    title('Total Cable Length')
    
    
    subplot(3,4,7)
    hist(cat(2,cat(2,stats.gstats.mblen)))
    title('Mean Branch Length')
    
    subplot(3,4,8)
    hist(cat(2,cat(2,stats.gstats.mplen)))
    title('Mean Path Length')
    
    subplot(3,4,9)
    hist(cat(2,cat(2,stats.gstats.max_plen)))
    title('Max Path Length')
    
    subplot(3,4,10)
    hist(cat(2,stats.gstats.bpoints))
    title('Number of Branch Points')
end
% %%
% tc= []; bc =[]; cc=[];
% for i = 1:numel(clay.trees)
% tc = cat(1,tc,sum(T_tree(clay.trees{i})));
% bc = cat(1,bc,sum(B_tree(clay.trees{i})));
% cc = cat(1,cc,sum(C_tree(clay.trees{i})));
% end
% 
% t35= []; b35 =[]; c35=[];
% for i = 1:numel(trees{1})
% t35 = cat(1,t35,sum(T_tree(trees{1}{i})));
% b35 = cat(1,b35,sum(B_tree(trees{1}{i})));
% c35 = cat(1,c35,sum(C_tree(trees{1}{i})));
% end
% 
