function waitForEnterPress ()
while true
    w = waitforbuttonpress;
    switch w
        case 1 % (keyboard press)
            key = get(gcf,'currentcharacter');
            switch key
                case 13 % 13 is the return key
                    disp('User pressed the return key')
                    break
                otherwise
                    % Wait for a different command.
            end
    end
end
