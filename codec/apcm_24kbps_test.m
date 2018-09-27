%% Resample and save

[y_in, Fs] = audioread('ohyeah.wav');

%sound(y_in,Fs)

T = 1/Fs;

y_in = y_in(:,1)';

Fs_new = 8e3;

[P,Q] = rat(Fs_new/Fs);

y_voice = resample(y_in,P,Q);

Fs_voice = Fs_new;

filename = 'ohyeah_voice.wav';
 
audiowrite(filename,y_voice,Fs_voice);

sound(y_voice,Fs_voice)

%% Encode
clear
close all

IndexTable = [
	-1, -1, 2, 6,...
    -1, -1, 2, 6,
];

StepSizeTable = [
    7, 8, 9, 10, 11, 12, 13, 14, 16, 17,...
    19, 21, 23, 25, 28, 31, 34, 37, 41, 45,...
    50, 55, 60, 66, 73, 80, 88, 97, 107, 118,...
    130, 143, 157, 173, 190, 209, 230, 253, 279, 307,...
    337, 371, 408, 449, 494, 544, 598, 658, 724, 796,...
    876, 963, 1060, 1166, 1282, 1411, 1552, 1707, 1878, 2066,...
    2272, 2499, 2749, 3024, 3327, 3660, 4026, 4428, 4871, 5358,...
    5894, 6484, 7132, 7845, 8630, 9493, 10442, 11487, 12635, 13899,...
    15289, 16818, 18500, 20350, 22385, 24623, 27086, 29794, 32767
];

[y_in, Fs] = audioread('ohyeah_voice.wav');

%sound(y_in,Fs);

y_in = floor((2^15).*y_in');
L = length(y_in);

state.prevsample = 0;
state.previndex = 1;

y_adpcm = zeros(1, L);

for i = 1:L
    
    sample = y_in(i);
    
    % Continue from last predicted sample
    predsample = state.prevsample;
    index = state.previndex;
    step = StepSizeTable(index);
    
    % Compute difference between current sample and predicted
    diff = sample - predsample;
    
    % ADPCM format: SABC
    
    % Set sign bit (S)
    if diff >= 0
        code = 0;
    else
        code = 4;
        diff = -diff;
    end
    
    % Store quantizer step size in temp
    tempstep = step;
    
    % *** QUANTIZER ***
    % Quantize difference

    % Bit 1 (A)
    if diff >= tempstep
        code = bitor(code, 2);
        diff = diff - tempstep;
    end
    tempstep = bitshift(tempstep, -1);
    % Bit 0 (B)
    if diff >= tempstep
        code = bitor(code, 1);
    end
    
    % *** INVERSE QUANTIZER ***
    diffq = bitshift(step, -3);
    % Bit 1 (A)
    if bitand(code, 2)
        diffq = diffq + bitshift(step, -1);
    end
    % Bit 0 (B)
    if bitand(code, 1)
        diffq = diffq + bitshift(step, -2);
    end
    
    % Fix sign (S)
    if bitand(code, 4)
        predsample = predsample - diffq;
    else
        predsample = predsample + diffq;
    end
    
    % Limit
    if (predsample > 32767)
        predsample = 32767;
    elseif (predsample < -32768)
        predsample = -32768;
    end
    
    % Advance index
    index = index + IndexTable(code + 1);
    
    % Limit index
    if index < 1
        index = 1;
    elseif index > 89
       index = 89; 
    end
    
    % Save state
    state.prevsample = predsample;
    state.previndex = index;
    
    % Emit code
    y_adpcm(i) = bitand(code, 7);
end

plot(1:L, [y_adpcm]); title("ADPCM encoded signal")

%% Decode
close all;

state.prevsample = 0;
state.previndex = 1;

y_out = zeros(1, L);

for i = 1:L
    
    code = y_adpcm(i);
    
    % Continue from last predicted sample
    predsample = state.prevsample;
    index = state.previndex;
    
    % Find the step size
    step = StepSizeTable(index);
    
    % *** INVERSE QUANTIZER ***
    diffq = bitshift(step, -3);
    % Bit 1 (A)
    if bitand(code, 2)
        diffq = diffq + bitshift(step, -1);
    end
    % Bit 0 (B)
    if bitand(code, 1)
        diffq = diffq + bitshift(step, -2);
    end
    
    % Fix sign (S)
    if bitand(code, 4)
        predsample = predsample - diffq;
    else
        predsample = predsample + diffq;
    end
    
    % Limit
    if (predsample > 32767)
        predsample = 32767;
    elseif (predsample < -32768)
        predsample = -32768;
    end
    
    % Advance index
    index = index + IndexTable(code + 1);
    
    % Limit index
    if index < 1
        index = 1;
    elseif index > 89
       index = 89; 
    end
    
    % Save state
    state.prevsample = predsample;
    state.previndex = index;
    
    % Emit sample
    y_out(i) = predsample;
end

plot(1:L, [y_in; y_out])
sound(y_out.*(2^-15), Fs);
