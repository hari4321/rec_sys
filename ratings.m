function rat = ratings(filename, dataLines)
%IMPORTFILE Import data from a text file
%  RAT = IMPORTFILE(FILENAME) reads data from text file FILENAME for the
%  default selection.  Returns the data as a table.
%
%  RAT = IMPORTFILE(FILE, DATALINES) reads data for the specified row
%  interval(s) of text file FILENAME. Specify DATALINES as a positive
%  scalar integer or a N-by-2 array of positive scalar integers for
%  dis-contiguous row intervals.
%
%  Example:
%  rat = ratings("C:\Users\harip\Desktop\Recommendations\rec_sys_2\ratings.dat", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 12-Jun-2021 10:03:06

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ":";

% Specify column names and types
opts.VariableNames = ["userId", "movieId", "ratings", "Var4"];
opts.SelectedVariableNames = ["userId", "movieId", "ratings"];
opts.VariableTypes = ["double", "double", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, "Var4", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Var4", "EmptyFieldRule", "auto");

% Import the data
rat = readtable(filename, opts);

end