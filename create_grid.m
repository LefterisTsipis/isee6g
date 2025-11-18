function [UE, MeNB, HotSpot, Grid] = create_grid(T, M, h, NMeNB, RMacro, RHotSpot, uheight, mheight, PtdBm)
    theta = 0:60:360;

    xCMeNB = zeros(1, NMeNB);
    yCMeNB = zeros(1, NMeNB);
    xPMeNB = zeros(NMeNB, length(theta));
    yPMeNB = zeros(NMeNB, length(theta));

    xCMeNB(1) = 0;
    yCMeNB(1) = 0;
    xPMeNB(1, :) = xCMeNB(1) + RMacro*sind(theta);
    yPMeNB(1, :) = yCMeNB(1) + RMacro*cosd(theta);

    xCMeNB(2) = sqrt(3) * RMacro * cosd(0);
    yCMeNB(2) = sqrt(3) * RMacro * sind(0);
    xPMeNB(2, :)  = xCMeNB(2) + RMacro * sind(theta);
    yPMeNB(2, :) = yCMeNB(2) + RMacro * cosd(theta);

    xCMeNB(3) = (sqrt(3) * RMacro / 2)*cosd(0);
    yCMeNB(3) = (sqrt(3) * RMacro) * sind(60);
    xPMeNB(3, :)  = xCMeNB(3) + RMacro * sind(theta);
    yPMeNB(3, :) = yCMeNB(3) + RMacro * cosd(theta);
    
    xCMeNB(4) = (sqrt(3) * RMacro / 2)*cosd(180);
    yCMeNB(4) = (sqrt(3) * RMacro) * sind(60);
    xPMeNB(4, :)  = xCMeNB(4) + RMacro * sind(theta);
    yPMeNB(4, :) = yCMeNB(4) + RMacro * cosd(theta);

    XMAX = max(max(xPMeNB));
    YMAX = max(max(yPMeNB));
    XMIN = min(min(xPMeNB));
    YMIN = min(min(yPMeNB));
    
    Grid = struct([]);
    Grid(1).XMAX = XMAX;
    Grid(1).XMIN = XMIN;
    Grid(1).YMIN = YMIN;
    Grid(1).YMAX = YMAX;
    Grid(1).xPMeNB = xPMeNB;
    Grid(1).yPMeNB = yPMeNB;

    g = 1;
    th = 0:pi/100:2*pi;
    xCHotSpot = zeros(h, 1);
    yCHotSpot = zeros(h, 1);
    while(g <= h)
        xCHotSpot(g) = (XMAX-XMIN) * rand(1,1) + XMIN;
        yCHotSpot(g) = (YMAX-YMIN) * rand(1,1) + YMIN;
        hin = 0;
        for i=1:NMeNB
            xtest = RHotSpot * cos(th) + xCHotSpot(g);
            ytest = RHotSpot * sin(th) + yCHotSpot(g);
            cin = 0;
            for j=1:g-1
                xvalid = RHotSpot * cos(th) + xCHotSpot(j);
                yvalid = RHotSpot * sin(th) + yCHotSpot(j);
                cin = cin + inpolygon(xtest, ytest, xvalid, yvalid);
            end
            if(cin == 0)
                hin = hin + inpolygon(xtest, ytest, xPMeNB(i, :), yPMeNB(i, :));
            else
                hin = -Inf;
                break;
            end
        end
        if(hin > 0)

            g = g + 1;
        end
    end

    U = 0;
    xu = [];
    yu = [];
    for i=1:h
        %n = poissrnd(M);
        %n = M;
        n = min(poissrnd(M), M);
        t = 2 * pi * rand(n, 1);
        r = RHotSpot * sqrt(rand(n, 1));
        xu = [xu; xCHotSpot(i) + r .* cos(t)];
        yu = [yu; yCHotSpot(i) + r .* sin(t)];
        U = U + n;
    end
    
    % --- Start Plot users inside Hotspots ---
    %{
    scatter(xu, yu, 'k', 'filled');
    %}
    % --- End Plot users inside Hotspots ---

    e = 2 * RHotSpot;
    xs = zeros(T - U, 1);
    ys = zeros(T - U, 1);
    for i=1:T - U
        xs(i) = (XMAX-XMIN) * rand(1,1) + XMIN;
        ys(i) = (YMAX-YMIN) * rand(1,1) + YMIN;
        bin = 0;
        for j=1:NMeNB
            bin = bin + inpolygon(xs(i), ys(i), xPMeNB(j, :), yPMeNB(j, :));
        end
        d = sqrt((xs(i) - xCHotSpot).^2 + (ys(i) - yCHotSpot).^2);
        while(min(d) <= RHotSpot + e || bin <= 0)
            xs(i) = (XMAX-XMIN) * rand(1,1) + XMIN;
            ys(i) = (YMAX-YMIN) * rand(1,1) + YMIN;
            bin = 0;
            for j=1:NMeNB
                bin = bin + inpolygon(xs(i), ys(i), xPMeNB(j, :), yPMeNB(j, :));
            end
            d = sqrt((xs(i) - xCHotSpot).^2 + (ys(i) - yCHotSpot).^2);
        end
    end
    % --- Start Plot users inside Hotspots ---
    %{
    hold on
    scatter(xs, ys, 'g', 'filled');
    %}
    % --- End Plot users inside Hotspots ---
    xu = [xu;xs];
    yu = [yu;ys];
    UE = struct([]);
    for i=1:T
        UE(i).id = i;
        UE(i).x = xu(i);
        UE(i).y = yu(i);
        UE(i).z = uheight;
    end
    MeNB = struct([]);
    for i=1:length(xCMeNB)
        MeNB(i).x = xCMeNB(i);
        MeNB(i).y = yCMeNB(i);
        MeNB(i).id = i;
        MeNB(i).z = mheight;
        MeNB(i).PtdBm = PtdBm;
        MeNB(i).Pt = 10^((PtdBm-30)/10);
    end
    HotSpot = struct([]);
    for i=1:h
        HotSpot(i).x = xCHotSpot(i);
        HotSpot(i).y = yCHotSpot(i);
    end
    %{
   hold on
    scatter([MeNB.x],[MeNB.y],'b','filled');
       hold on
    scatter([UE.x],[UE.y],'r','filled');
     hold on
    scatter([HotSpot.x],[HotSpot.y],'g','filled');
    %}
end