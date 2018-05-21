clear
commandwindow
% Simple program for solving the advection equation
%%%%%%%%%%%%
%% Set up parameters
tau=.1; %input('Enter timestep:');
N = 700;% input('Enter N steps:');    
c = 1;                  % Wave speed
L = 5.0;                % Length of domain
h = L/N;                % Space grid size
x = -L/2+h/2+(0:N-1)*h; % Space coordinate
tau = h/c;             % Stability limit
clf
%inserting image as background of initial screen
ylim([0, 8]); xlim([1,2]);  
img = imread('city.png');
imagesc([1 2], [0 8], img);
axis off
%setting limits of y axis
ylowlimit = 0;
yuplimit = 8;
%game start message
title('Floaty Shape', 'Color', 'black', 'FontSize', 25, 'FontName','Goudy Stout')
text(1.1, 4, '"W" to Float and "S" to Dive', 'Color', 'blue', 'FontSize', 20, 'FontName','HoboSTD' )
text(1.1, 3, 'Good Luck!', 'Color', 'blue', 'FontSize', 20, 'FontName','HoboSTD' )
text(1.1, 2, 'Press any button to continue...', 'Color', 'blue', 'FontSize', 20, 'FontName','HoboSTD' )
lives=1;    %counter for lives
level = 0;  %counter for levels
xofy = 1.2/h;
b = zeros(N+1,1);
b = b+4;
a = zeros(N+1,1);       % Numerical solution vector
xi = 1:N;               % Index counters
xm = [2:N 1];
xp = [N 1:N-1];
%initializing color and shape
colorshift = 1;
color ='blue';
shapeshift = 0;
shape = 's';
%initializing counters for creating pulses at bottom and top
bottom = 5;
top = 5;
space = 100;
%initializing positions to be used for coins
c1x=0;
c1y=0;
c1x2=0;
c1y2=0;
coinnumber = 0;
CoinCounter = 0;
% Define initial pulse
a=  2./cosh(5*x.^2/h).^2;    % initial bottom pulse
b= - 2./cosh(5*x.^2/h).^2 +7; % initial top pulse
%%%%%%%%%%%%
%% Run the loop
pause;
clf
plot(x,a,'-o'); ylim([-1,1.5]);



coeff_ftcs = -c*tau/(2.*h);
istep = 1;
t=0;    %initializing time
v = 0;  %initializing velocity (only y-direction)
accel = -100;   %constant acceleration (only y-direction)

America = 0;    %constant for special 'America mode'
set(gcf,'CurrentCharacter','@'); % set to a dummy character for flapping

while lives > 0
    lives = lives -1;
%     y= (b(700*h*1.2 +350) + a(700*h*1.2 +350))/2;
    y = (a(round(1.2/h + 700/2 +3))+.1 + (b(round(1.2/h + 700/2 + 3))-.15))/2;
    v = 0;
    %loops runs as long as shape doesn't touch barriers
    while((y > a(round(1.2/h + 700/2 +3))+.1) && (y < (b(round(1.2/h + 700/2 + 3))-.15))) | (y > (b(round(1.2/h + 700/2 + 3))+.4)) | (y < (a(round(1.2/h + 700/2 + 3))-.3));
        
        if y > 30   % if you go too high, sends you underneath
            y = -20;
        elseif y< -30 %if you go too low, sends you up top
            y = 20;
        end
        
        if rem(istep +3599, 3600) ==0 %loops the audio player so music continues
            [u, Fs] = audioread('SuperMarioBros.mp3');
            player = audioplayer(u, Fs);
            play(player);
        end
        
        k=get(gcf,'CurrentCharacter');    %% Flap! check for key to change velocity
        if k~='@' % has it changed from the dummy character?
            set(gcf,'CurrentCharacter','@'); % reset the character
            %process the key
            if k=='w'
                v = 11.7;   %shape has velocity upwards
            elseif k=='s'
                v = v - 10;   % DIVE - negative velocity
            elseif k =='o' % Easter Egg
                b(500:600) = 0; %opens up the top barrier by setting it to 0
            elseif k=='m'   %Easter Egg
                stop(player);   %stops current player, plays amerika music
                [l, Fl] = audioread('Amerika.mp3');
                player = audioplayer(l, Fl);
                play(player);
                America = 1;
            elseif k=='l'   %Easter Egg
                a(500:600) = 7; %opens up the bottom barrier by setting it to the top
            end
        end
        
        %calculate velocity of shape using acceleration and time
        v = v + accel*tau;  %new velocity
        %calculate position of shape using velocity and time
        y = y + v*tau;  %new position
                
        % Lax-Wendroff method
        a(xi) = 1.0*(a(xi) + coeff_ftcs*(a(xp)-a(xm))+ (2*(coeff_ftcs)^2)*(-2*a(xi)+a(xp)+a(xm)));  % Bottom avection
        b(xi) = 1.0*(b(xi) + coeff_ftcs*(b(xp)-b(xm))+ (2*(coeff_ftcs)^2)*(-2*b(xi)+b(xp)+b(xm)));  % Top avection
        b(400) = 7;  % Erase past top barriers
        a(400) = 0;  % Erase past bottom barriers
       
        figure(1)
        %creating background and text for GUI
        imagesc([2 1], [8 0], img);
        set(gca,'Ydir','Normal')
        hold on;
        plot(x,a,'-', 'LineWidth', 5); ylim([ylowlimit, yuplimit]); xlim([1,2])
        hold on
        plot(x,b,'-', 'LineWidth', 5);
        score='SCORE ';
        text(1, 15, 'Fly away! Be Free!','Color', 'black','FontSize', 50);%extra text for Easter Egg
        text(1.5, 7.5, [score, num2str(istep), '  LEVEL ', num2str(level)], 'Color', 'blue', 'FontSize', 20, 'FontName','HoboSTD' );
        text(1, 7.5, ['Coins ', num2str(CoinCounter)], 'Color', 'blue', 'FontSize', 20, 'FontName','HoboSTD' );
        text(1.2, 7.5, ['Lives ', num2str(lives)], 'Color', 'blue', 'FontSize', 20, 'FontName','HoboSTD' );
        %creates shape with properties controlling height, 
        %shape, and color (y
        plot(1.2, y ,shape,'MarkerFaceColor',color, 'MarkerEdgeColor', color, 'MarkerSize', 20);
        title('Floaty Shape', 'Color', 'black', 'FontSize', 25, 'FontName','Goudy Stout');
        axis off
        
        istep = istep +1;   %counts number of loops run      
        %levels up every 500 loops
        if rem(istep, 500) == 0
            level = level + 1;
            text(1.3, 4, 'LEVEL UP!', 'Color', 'black', 'FontSize', 35);
            if level < 10
                space = space - 5;
            end
        end
        
        
        
        r3 = round(rand * 50);      % Idea to collect coins for more points
        r4 = round(rand * 150);
        %choosing where to place coins
        if r3 == 1 && c1x < 1
            c1x = 2.1;
            %initializing the height of the coin to a random spot
            %somewhere between the top and bottom boundaries
            c1y =rand()*abs((a(round(2.1/h + 700/2 +3))+.15 - (b(round(2.1/h + 700/2 + 3))-.15))) + (a(round(2.1/h+350)));
        end
        if r4 == 1 && c1x2 < 1
            c1x2 = 2.5;
            c1y2 =15+rand()*10;
        end
        c1x = c1x - h;
        c1x2 = c1x2 - h;
        plot(c1x, c1y, 'o', 'MarkerSize', 10,'MarkerFaceColor',[1,.87,.27] );
        plot(c1x2, c1y2, 'o', 'MarkerSize', 30,'MarkerFaceColor',[1,.87,.27] );
        %calculating if the shape and the coin are at the same spot
        if c1x < 1.25 & c1x > 1.15 & abs(c1y - y) < .3
            CoinCounter = CoinCounter +1;
            c1x = 0;
            %sound effect
            [p, Fp] = audioread('coin_sound.mp3'); 
            coinsound = audioplayer(p, Fp);
            play(coinsound); 
        end
        if c1x2 < 1.25 & c1x2 > 1.15 & abs(c1y2 - y) < .3
            CoinCounter = CoinCounter +5;
            c1x2 = 0;
            %sound effect
            [p, Fp] = audioread('coin_sound.mp3'); 
            coinsound = audioplayer(p, Fp);
            play(coinsound); 
        end        
        if CoinCounter > 4 %adds a life if you have collected 5 coins
            CoinCounter = CoinCounter -5;
            lives = lives +1;
            %sound effect
            [m, Fm] = audioread('mushroom_effect.mp3');
            mushroom = audioplayer(m, Fm);
            play(mushroom); 
        end
        hold off
        pause(.01);
        x0(istep)=a(1);
        t = tau + t;
        time(istep) = t;
        c=c+.1;
        
        
        %generating random numbers between 0 and 4.5
        r1 = rand * 4.5;
        r2 = rand * 4.5;
        
        bottom = bottom + 1;
        top = top +1;
        if r1 + r2 > 6 %don't add bump if r1 + r2 > 6
            continue
        else    %possiblity for a top bump if not too close to a top bump
            if round(r1*5) == 1 & bottom > 10 & top > 10 & (6-r1) + top > space
                b= b +(-(r2)*(1./cosh(5*x.^2/h).^2));
                top = 0;
            end
            %possiblity for a bottom bump if not too close to a bottom bump
            if  round(r2*5)== 1 & top > 10 & bottom > 10 & (6-r2)+ bottom > space
                a= a + (r1)*1./cosh(5*x.^2/h).^2;
                bottom = 0;
            end
        end
        
        %object changes shape depending on which level you're at
        if rem(istep, 500) == 0
            shapeshift = shapeshift + 1;
            if rem(shapeshift,6) == 0
                shape = 's';
            elseif rem(shapeshift,6) == 1
                shape = 'o';
            elseif rem(shapeshift,6) == 2
                shape = 'd';
            elseif rem(shapeshift,6) == 3
                shape = 'h';
            elseif rem(shapeshift,6) == 4
                shape = 'x';
            elseif rem(shapeshift,6) == 5
                shape = '*';
            end
            
        end
        
        %Easter Egg - America mode
        if America == 1 %Shape is a star when America plays
            shape = 'p';
        end
        
        %changes color every while loop, with exceptions for America mode
        if rem(istep, 7) == 0
            colorshift = colorshift + 1;
            if rem(colorshift,6) == 0
                color = 'r';
            elseif rem(colorshift,7) == 1
                if America == 1
                    continue
                else
                    color = 'g';
                end
            elseif rem(colorshift,7) == 2
                color = 'b';
            elseif rem(colorshift,7) == 3
                if America == 1
                    continue
                else
                    color = 'c';
                end
            elseif rem(colorshift,7) == 4
                if America == 1
                    continue
                else
                    color = 'm';
                end
            elseif rem(colorshift,7) == 5
                if America == 1
                    continue
                else
                    color = 'y';
                end
            elseif rem(colorshift, 7) ==6 && America == 1
                color = 'white';  
            end
        end
        
        
        %special case for view if you go beyond the normal 
        %boundaries of the game
        if  y > 8 | y < 0;
            ylowlimit = y-3.5;   %%Sets view to follow you when you escape
            yuplimit = y+3.5;
            
        else    %sets limit of y-axis to 0 and 8
            ylowlimit = 0;
            yuplimit = 8;
        end
        
    end

if lives > 0    %messages for when you die but still have lives remaining
    text(1.2, 4, '\bf We''re dead!  We''re dead!', 'Color', 'black', 'FontSize', 20);
    text(1.2, 3.5, '\bf We survived! But we''re dead!', 'Color', 'black', 'FontSize', 20);
    text(1.2, 2, '\bf Press any key to continue.', 'Color', 'black', 'FontSize', 20);
    pause
end


end
stop(player);   %stops audio player
        %play losing music
     [q, Fq] = audioread('SadTrombone.mp3');
     Trombone = audioplayer(q, Fq);
     play(Trombone); 
%game over message
text(1.2, 4, '\bf GAME OVER', 'Color', 'black', 'FontSize', 35);
text(1.4, 2.7, '\bf LOSER', 'Color', 'black', 'FontSize', 35, 'FontName', 'Arial Black', 'FontWeight', 'bold', 'Rotation', 20);
