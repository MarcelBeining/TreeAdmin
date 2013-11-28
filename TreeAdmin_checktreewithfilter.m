function isok = TreeAdmin_checktreewithfilter(tree,filter)

isok = false;

fil.lateral_side = {'ipsi','contra'};
fil.lateral_side(~[filter.check_ipsi,filter.check_contra]) = [];
fil.pyramidal_blade = {'supra','infra'};
fil.pyramidal_blade(~[filter.check_supra,filter.check_infra]) = [];
fil.HFS = {'yes','no'};
fil.HFS(~[filter.check_HFS_pos,filter.check_HFS_neg]) = [];
fil.arc = {'positive','negative'};
fil.arc(~[filter.check_arc_pos,filter.check_arc_neg]) = [];
fil.done = {'yes','no'};
fil.done(~[filter.check_done,filter.check_notdone]) = [];
filter_names = {'done','HFS','lateral_side','pyramidal_blade','arc'};

for f = 1:numel(filter_names)
    if numel(fil.(filter_names{f})) ~= 0
        if isempty(tree.(filter_names{f})) || ~any(strcmp(tree.(filter_names{f}),fil.(filter_names{f})))
            return
        end
    end
end

if filter.check_dpi && (isempty(tree.dpi) || ~(tree.dpi >= filter.dpi_min && tree.dpi  <= filter.dpi_max))
    return
end

if filter.check_completeness && (isempty(tree.completeness) || ~(tree.completeness >= filter.completeness_min && tree.completeness  <= filter.completeness_max))
    return
end

isok = true;