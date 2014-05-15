function structOfArrays = transpose_arrayOfStructs( arrayOfStructs )

fields = fieldnames(arrayOfStructs(1));

for i = 1:length(fields)

    field = fields{i};

    % When field = 'a', this is like saying:
    %   structOfArrays.a = [arrayOfStructs.a];
    structOfArrays.(field) = [arrayOfStructs.(field)];

end

end

