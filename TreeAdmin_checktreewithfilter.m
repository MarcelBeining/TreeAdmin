function isok = TreeAdmin_checktreewithfilter(tree,filter)

isok = false;

fil.lateral_side = {'ipsi','contra'};
fil.lateral_side(~[filter.ipsi,filter.contra]) = [];
fil.pyramidal_blade = {'supra','infra'};
fil.pyramidal_blade(~[filter.supra,filter.infra]) = [];
fil.HFS = {'yes','no'};
fil.HFS(~[filter.HFS_pos,filter.HFS_neg]) = [];
fil.arc = {'positive','negative'};
fil.arc(~[filter.arc_pos,filter.arc_neg]) = [];
fil.done = {'yes','no'};
fil.done(~[filter.done_yes,filter.done_no]) = [];
filter_names = {'done','HFS','lateral_side','pyramidal_blade','arc'};

for f = 1:numel(filter_names)
    if numel(fil.(filter_names{f})) ~= 0
        if isempty(tree.(filter_names{f})) || ~any(strcmp(tree.(filter_names{f}),fil.(filter_names{f})))
            return
        end
    end
end

if filter.dpi_ok && (isempty(tree.dpi) || ~(tree.dpi >= filter.dpi_min && tree.dpi  <= filter.dpi_max))
    return
end

if filter.completeness_ok && (isempty(tree.completeness) || ~(tree.completeness >= filter.completeness_min && tree.completeness  <= filter.completeness_max))
    return
end

isok = true;