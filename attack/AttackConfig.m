classdef AttackConfig
   properties
      filters (:,1) FilterConfiguration
      lazy logical = true
   end
   methods
      function rp = mappings(obj)
        s = size(obj.filters, 1)
        p = perms(linspace(1,s,s));
        rp = p(randperm(size(p, 1)), :);
      end
   end
end
