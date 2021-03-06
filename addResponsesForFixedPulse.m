function R2 = addResponsesForFixedPulse(R, val)

valstr = strrep(num2str(val), '-', 'n');
R2 = struct([]);
for ii = 1:numel(R)
    r = R(ii);
    if val < 0
        r.(['A1resp_pulse_' valstr]) = r.A1resp(r.A1_revPulseIdx == val);
        r.(['A2resp_pulse_' valstr]) = r.A2resp(r.A2_revPulseIdx == val);
    else
        r.(['A1resp_pulse_' valstr]) = r.A1resp(r.A1_pulseIdx == val);
        r.(['A2resp_pulse_' valstr]) = r.A2resp(r.A2_pulseIdx == val);
    end
    R2 = [R2 r];
end

end
