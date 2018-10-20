%% simple norm

function [normOutput] = simpleNorm(vector, type)



switch type
    
    case '0and1'
        normOutput = (vector - min(vector)) / ( max(vector) - min(vector) );
        
    case '1and0'
        normOutput = (vector - min(vector)) / ( max(vector) - min(vector) );
        
    case '-1and1'
        [normOutput] =normalised_diff( vector );
        
    case '1and-1'
        [normOutput] = normalised_diff( vector );
end

    function norm_value = normalised_diff( data )
        % Normalise values of an array to be between -1 and 1
        % original sign of the array values is maintained.
        if abs(min(data)) > max(data)
            max_range_value = abs(min(data));
            min_range_value = min(data);
        else
            max_range_value = max(data);
            min_range_value = -max(data);
        end
        norm_value = 2 .* data ./ (max_range_value - min_range_value);
    end
end