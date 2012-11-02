function isok = TreeAdmin_checktreewithfilter(tree,filter)

isok = false;

lateral_side = {'ipsi','contra'};
lateral_side(~[filter.ipsi,filter.contra]) = [];
pyramidal_blade = {'supra','infra'};
pyramidal_blade(~[filter.supra,filter.infra]) = [];
HFS = {'yes','no'};
HFS(~[filter.HFS_pos,filter.HFS_neg]) = [];
arc = {'positive','negative'};
arc(~[filter.arc_pos,filter.arc_neg]) = [];
done = {'yes','no'};
done(~[filter.done_yes,filter.done_no]) = [];

if filter.dpi_ok && (isempty(tree.dpi) || ~(tree.dpi >= filter.dpi_min && tree.dpi  <= filter.dpi_max))
    return
end

% switch sum([filter.HFS_pos,filter.HFS_neg])
%     case 1
%         if isempty(tree.HFS) || tree.HFS == 1 - filter.HFS_pos
%             return
%         end
%     case 2
%         if isempty(tree.HFS)
%             return
%         end
% end
switch numel(done)
    case 1
        if isempty(tree.done) || ~any(strcmp(tree.done,done))
            return
        end
    case 2
        if isempty(tree.done)
            return
        end
end

switch numel(HFS)
    case 1
        if isempty(tree.HFS) || ~any(strcmp(tree.HFS,HFS))
            return
        end
    case 2
        if isempty(tree.HFS)
            return
        end
end

switch numel(lateral_side)
    case 1
        if isempty(tree.lateral_side) || ~any(strcmp(tree.lateral_side,lateral_side))
            return
        end
    case 2
        if isempty(tree.lateral_side)
            return
        end
end

switch numel(pyramidal_blade)
    case 1
        if isempty(tree.pyramidal_blade) || ~any(strcmp(tree.pyramidal_blade,pyramidal_blade))
            return
        end
    case 2
        if isempty(tree.pyramidal_blade)
            return
        end
end

% switch sum([filter.arc_pos,filter.arc_neg])
%     case 1
%         if isempty(tree.arc) || tree.arc == 1 - filter.arc_pos
%             return
%         end
%     case 2
%         if isempty(tree.arc)
%             return
%         end
% end

switch numel(arc)
    case 1
        if isempty(tree.arc) || ~any(strcmp(tree.arc,arc))
            return
        end
    case 2
        if isempty(tree.arc)
            return
        end
end

if filter.completeness_ok && (isempty(tree.completeness) || ~(tree.completeness >= filter.completeness_min && tree.completeness  <= filter.completeness_max))
    return
end

isok = true;