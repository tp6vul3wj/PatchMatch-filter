function good_inds = uniform_sample(pos,no)

%keyboard
d = dist2(pos,pos).^0.5;

ni = size(pos,1);
good = zeros(ni,1);


rp = randperm(ni);


good(rp(1))=1;
good_inds = find(good);
bad_inds = find(good==0);

done = sum(good);
while ( done < no ) && ( done < ni ),
  dists = min(d(good_inds,:),[],1);
  dists = dists(bad_inds);
  [sd,si]=sort(-dists);
  si=si(1);
  good(bad_inds(si))=1;
  good_inds = find(good);
  bad_inds = find(good==0);
  done = sum(good);
end

