function [UEs] = find_outage_users(UE, MeNB, threshold)
%% --- Compute serving MeNB for each UE ---
nUE   = numel(UE);
nMeNB = numel(MeNB);

for i = 1:nUE
    for j = 1:nMeNB
        
        d = pdist([MeNB(j).x, MeNB(j).y, MeNB(j).z;
                   UE(i).x,  UE(i).y,  UE(i).z]);

        UE(i).distMeNB(j)  = d;
        UE(i).PLMeNBdB(j)  = MNLOS(d);
        UE(i).PrMenBdBm(j) = MeNB(j).PtdBm - UE(i).PLMeNBdB(j);
    end
    
    % Find the best MeNB
    [~, bestID] = max(UE(i).PrMenBdBm);

    UE(i).EnB_ID   = bestID;
    UE(i).distMeNB  = UE(i).distMeNB(bestID);
    UE(i).PLMeNBdB  = UE(i).PLMeNBdB(bestID);
    UE(i).PrMenBdBm = UE(i).PrMenBdBm(bestID);

    % Outage condition
    if UE(i).PrMenBdBm < threshold
        UE(i).EnB_ID = -1;
    end
end

%% ---- KEEP ONLY OUTAGE USERS ----
UEs = UE([UE.EnB_ID] == -1);

end
