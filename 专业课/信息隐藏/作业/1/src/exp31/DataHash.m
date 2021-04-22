function Hash = DataHash(Data, varargin)
% DATAHASH - Checksum for Matlab array of any type
% This function creates a hash value for an input of any type. The type and
% dimensions of the input are considered as default, such that UINT8([0,0]) and
% UINT16(0) have different hash values. Nested STRUCTs and CELLs are parsed
% recursively.
%
% Hash = DataHash(Data, Opts...)
% INPUT:
%   Data: Array of these built-in types:
%           (U)INT8/16/32/64, SINGLE, DOUBLE, (real/complex, full/sparse)
%           CHAR, LOGICAL, CELL (nested), STRUCT (scalar or array, nested),
%           function_handle, string.
%   Opts: Char strings to specify the method, the input and theoutput types:
%         Input types:
%            'array': The contents, type and size of the input [Data] are
%                     considered  for the creation of the hash. Nested CELLs
%                     and STRUCT arrays are parsed recursively. Empty arrays of
%                     different type reply different hashs.
%            'file':  [Data] is treated as file name and the hash is calculated
%                     for the files contents.
%            'bin':   [Data] is a numerical, LOGICAL or CHAR array. Only the
%                     binary contents of the array is considered, such that
%                     e.g. empty arrays of different type reply the same hash.
%            'ascii': Same as 'bin', but only the 8-bit ASCII part of the 16-bit
%                     Matlab CHARs is considered.
%         Output types:
%            'hex', 'HEX':      Lower/uppercase hexadecimal string.
%            'double', 'uint8': Numerical vector.
%            'base64':          Base64.
%            'short':           Base64 without padding.
%         Hashing method:
%            'SHA-1', 'SHA-256', 'SHA-384', 'SHA-512', 'MD2', 'MD5'.
%            Call DataHash without inputs to get a list of available methods.
%
%         Default: 'MD5', 'hex', 'array'
%
% OUTPUT:
%   Hash: String, DOUBLE or UINT8 vector. The length depends on the hashing
%         method.
%         If DataHash is called without inputs, a struct is replied:
%           .HashVersion: Version number of the hashing method of this tool. In
%              case of bugs or additions, the output can change.
%           .Date: Date of release of the current HashVersion.
%           .HashMethod: Cell string of the recognized hash methods.
%
% EXAMPLES:
% % Default: MD5, hex:
%   DataHash([])                      % 5b302b7b2099a97ba2a276640a192485
% % MD5, Base64:
%   DataHash(int32(1:10), 'short', 'MD5')  % +tJN9yeF89h3jOFNN55XLg
% % SHA-1, Base64:
%   S.a = uint8([]);
%   S.b = {{1:10}, struct('q', uint64(415))};
%   DataHash(S, 'SHA-1', 'HEX')       % 18672BE876463B25214CA9241B3C79CC926F3093
% % SHA-1 of binary values:
%   DataHash(1:8, 'SHA-1', 'bin')     % 826cf9d3a5d74bbe415e97d4cecf03f445f69225
% % SHA-256, consider ASCII part only (Matlab's CHAR has 16 bits!):
%   DataHash('abc', 'SHA-256', 'ascii')
%       % ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad
% % Or equivalently by converting the input to UINT8:
%   DataHash(uint8('abc'), 'SHA-256', 'bin')
%
% NOTES:
%   Function handles and user-defined objects cannot be converted uniquely:
%   - The subfunction ConvertFuncHandle uses the built-in function FUNCTIONS,
%     but the replied struct can depend on the Matlab version.
%   - It is tried to convert objects to UINT8 streams in the subfunction
%     ConvertObject. A conversion by STRUCT() might be more appropriate.
%   Adjust these subfunctions on demand.
%
%   MATLAB CHARs have 16 bits! Use Opt.Input='ascii' for comparisons with e.g.
%   online hash generators.
%
%   Matt Raum suggested this for e.g. user-defined objects:
%     DataHash(getByteStreamFromArray(Data))
%   This works very well, but unfortunately getByteStreamFromArray is
%   undocumented, such that it might vanish in the future or reply different
%   output.
%
%   For arrays the calculated hash value might be changed in new versions.
%   Calling this function without inputs replies the version of the hash.
%
%   The older style for input arguments is accepted also: Struct with fields
%     'Input', 'Method', 'OutFormat'.
%
%   The C-Mex function GetMD5 is 2 to 100 times faster, but obtains MD5 only:
%   http://www.mathworks.com/matlabcentral/fileexchange/25921
%
% Tested: Matlab 2009a, 2015b(32/64), 2016b, 2018b, Win7/10
% Author: Jan Simon, Heidelberg, (C) 2011-2019 matlab.2010(a)n(MINUS)simon.de
%
% See also: TYPECAST, CAST.
%
% Michael Kleder, "Compute Hash", no structs and cells:
%   http://www.mathworks.com/matlabcentral/fileexchange/8944
% Tim, "Serialize/Deserialize", converts structs and cells to a byte stream:
%   http://www.mathworks.com/matlabcentral/fileexchange/29457

% $JRev: R-R V:043 Sum:VbfXFn6217Hp Date:18-Apr-2019 12:11:42 $
% $License: BSD (use/copy/change/redistribute on own risk, mention the author) $
% $UnitTest: uTest_DataHash $
% $File: Tools\GLFile\DataHash.m $
% History:
% 001: 01-May-2011 21:52, First version.
% 007: 10-Jun-2011 10:38, [Opt.Input], binary data, complex values considered.
% 011: 26-May-2012 15:57, Fixed: Failed for binary input and empty data.
% 014: 04-Nov-2012 11:37, Consider Mex-, MDL- and P-files also.
%      Thanks to David (author 243360), who found this bug.
%      Jan Achterhold (author 267816) suggested to consider Java objects.
% 016: 01-Feb-2015 20:53, Java heap space exhausted for large files.
%      Now files are process in chunks to save memory.
% 017: 15-Feb-2015 19:40, Collsions: Same hash for different data.
%      Examples: zeros(1,1) and zeros(1,1,0)
%                complex(0) and zeros(1,1,0,0)
%      Now the number of dimensions is included, to avoid this.
% 022: 30-Mar-2015 00:04, Bugfix: Failed for strings and [] without TYPECASTX.
%      Ross found these 2 bugs, which occur when TYPECASTX is not installed.
%      If you need the base64 format padded with '=' characters, adjust
%      fBase64_enc as you like.
% 026: 29-Jun-2015 00:13, Changed hash for STRUCTs.
%      Struct arrays are analysed field by field now, which is much faster.
% 027: 13-Sep-2015 19:03, 'ascii' input as abbrev. for Input='bin' and UINT8().
% 028: 15-Oct-2015 23:11, Example values in help section updated to v022.
% 029: 16-Oct-2015 22:32, Use default options for empty input.
% 031: 28-Feb-2016 15:10, New hash value to get same reply as GetMD5.
%      New Matlab version (at least 2015b) use a fast method for TYPECAST, such
%      that calling James Tursa's TYPECASTX is not needed anymore.
%      Matlab 6.5 not supported anymore: MException for CATCH.
% 033: 18-Jun-2016 14:28, BUGFIX: Failed on empty files.
%      Thanks to Christian (AuthorID 2918599).
% 035: 19-May-2018 01:11, STRING type considered.
% 040: 13-Nov-2018 01:20, Fields of Opt not case-sensitive anymore.
% 041: 09-Feb-2019 18:12, ismethod(class(V),) to support R2018b.
% 042: 02-Mar-2019 18:39, base64: in Java, short: Base64 with padding.
%      Unit test. base64->short.

% OPEN BUGS:
% Nath wrote:
% function handle refering to struct containing the function will create
% infinite loop. Is there any workaround ?
% Example:
%   d= dynamicprops();
%   addprop(d,'f');
%   d.f= @(varargin) struct2cell(d);
%   DataHash(d.f) % infinite loop
% This is caught with an error message concerning the recursion limit now.

%#ok<*CHARTEN>

% Reply current version if called without inputs: ------------------------------
if nargin == 0
   R = Version_L;
   
   if nargout == 0
      disp(R);
   else
      Hash = R;
   end
   
   return;
end

% Parse inputs: ----------------------------------------------------------------
[Method, OutFormat, isFile, isBin, Data] = ParseInput(Data, varargin{:});

% Create the engine: -----------------------------------------------------------
try
   Engine = java.security.MessageDigest.getInstance(Method);
   
catch ME  % Handle errors during initializing the engine:
   if ~usejava('jvm')
      Error_L('needJava', 'DataHash needs Java.');
   end
   Error_L('BadInput2', 'Invalid hashing algorithm: [%s]. %s', ...
      Method, ME.message);
end

% Create the hash value: -------------------------------------------------------
if isFile
   [FID, Msg] = fopen(Data, 'r');        % Open the file
   if FID < 0
      Error_L('BadFile', ['Cannot open file: %s', char(10), '%s'], Data, Msg);
   end
   
   % Read file in chunks to save memory and Java heap space:
   Chunk = 1e6;          % Fastest for 1e6 on Win7/64, HDD
   Count = Chunk;        % Dummy value to satisfy WHILE condition
   while Count == Chunk
      [Data, Count] = fread(FID, Chunk, '*uint8');
      if Count ~= 0      % Avoid error for empty file
         Engine.update(Data);
      end
   end
   fclose(FID);
      
elseif isBin             % Contents of an elementary array, type tested already:
   if ~isempty(Data)     % Engine.update fails for empty input!
      if isnumeric(Data)
         if isreal(Data)
            Engine.update(typecast(Data(:), 'uint8'));
         else
            Engine.update(typecast(real(Data(:)), 'uint8'));
            Engine.update(typecast(imag(Data(:)), 'uint8'));
         end
      elseif islogical(Data)               % TYPECAST cannot handle LOGICAL
         Engine.update(typecast(uint8(Data(:)), 'uint8'));
      elseif ischar(Data)                  % TYPECAST cannot handle CHAR
         Engine.update(typecast(uint16(Data(:)), 'uint8'));
         % Bugfix: Line removed
      elseif myIsString(Data)
         if isscalar(Data)
            Engine.update(typecast(uint16(Data{1}), 'uint8'));
         else
            Error_L('BadBinData', 'Bin type requires scalar string.');
         end
      else  % This should have been caught above!
         Error_L('BadBinData', 'Data type not handled: %s', class(Data));
      end
   end
else                 % Array with type:
   Engine = CoreHash(Data, Engine);
end

% Calculate the hash: ----------------------------------------------------------
Hash = typecast(Engine.digest, 'uint8');
   
% Convert hash specific output format: -----------------------------------------
switch OutFormat
   case 'hex'
      Hash = sprintf('%.2x', double(Hash));
   case 'HEX'
      Hash = sprintf('%.2X', double(Hash));
   case 'double'
      Hash = double(reshape(Hash, 1, []));
   case 'uint8'
      Hash = reshape(Hash, 1, []);
   case 'short'
      Hash = fBase64_enc(double(Hash), 0);
   case 'base64'
      Hash = fBase64_enc(double(Hash), 1);
      
   otherwise
      Error_L('BadOutFormat', ...
         '[Opt.Format] must be: HEX, hex, uint8, double, base64.');
end

end

% ******************************************************************************
function Engine = CoreHash(Data, Engine)

% Consider the type and dimensions of the array to distinguish arrays with the
% same data, but different shape: [0 x 0] and [0 x 1], [1,2] and [1;2],
% DOUBLE(0) and SINGLE([0,0]):
% <  v016: [class, size, data]. BUG! 0 and zeros(1,1,0) had the same hash!
% >= v016: [class, ndims, size, data]
Engine.update([uint8(class(Data)), ...
              typecast(uint64([ndims(Data), size(Data)]), 'uint8')]);
           
if issparse(Data)                    % Sparse arrays to struct:
   [S.Index1, S.Index2, S.Value] = find(Data);
   Engine                        = CoreHash(S, Engine);
elseif isstruct(Data)                % Hash for all array elements and fields:
   F = sort(fieldnames(Data));       % Ignore order of fields
   for iField = 1:length(F)          % Loop over fields
      aField = F{iField};
      Engine.update(uint8(aField));
      for iS = 1:numel(Data)         % Loop over elements of struct array
         Engine = CoreHash(Data(iS).(aField), Engine);
      end
   end
elseif iscell(Data)                  % Get hash for all cell elements:
   for iS = 1:numel(Data)
      Engine = CoreHash(Data{iS}, Engine);
   end
elseif isempty(Data)                 % Nothing to do
elseif isnumeric(Data)
   if isreal(Data)
      Engine.update(typecast(Data(:), 'uint8'));
   else
      Engine.update(typecast(real(Data(:)), 'uint8'));
      Engine.update(typecast(imag(Data(:)), 'uint8'));
   end
elseif islogical(Data)               % TYPECAST cannot handle LOGICAL
   Engine.update(typecast(uint8(Data(:)), 'uint8'));
elseif ischar(Data)                  % TYPECAST cannot handle CHAR
   Engine.update(typecast(uint16(Data(:)), 'uint8'));
elseif myIsString(Data)              % [19-May-2018] String class in >= R2016b
   classUint8 = uint8([117, 105, 110, 116, 49, 54]);  % 'uint16'
   for iS = 1:numel(Data)
      % Emulate without recursion: Engine = CoreHash(uint16(Data{iS}), Engine)
      aString = uint16(Data{iS});
      Engine.update([classUint8, ...
         typecast(uint64([ndims(aString), size(aString)]), 'uint8')]);
      if ~isempty(aString)
         Engine.update(typecast(uint16(aString), 'uint8'));
      end
   end
   
elseif isa(Data, 'function_handle')
   Engine = CoreHash(ConvertFuncHandle(Data), Engine);
elseif (isobject(Data) || isjava(Data)) && ismethod(class(Data), 'hashCode')
   Engine = CoreHash(char(Data.hashCode), Engine);
else  % Most likely a user-defined object:
   try
      BasicData = ConvertObject(Data);
   catch ME
      error(['JSimon:', mfilename, ':BadDataType'], ...
         '%s: Cannot create elementary array for type: %s\n  %s', ...
         mfilename, class(Data), ME.message);
   end
   
   try
      Engine = CoreHash(BasicData, Engine);
   catch ME
      if strcmpi(ME.identifier, 'MATLAB:recursionLimit')
         ME = MException(['JSimon:', mfilename, ':RecursiveType'], ...
            '%s: Cannot create hash for recursive data type: %s', ...
            mfilename, class(Data));
      end
      throw(ME);
   end
end

end

% ******************************************************************************
function [Method, OutFormat, isFile, isBin, Data] = ParseInput(Data, varargin)

% Default options: -------------------------------------------------------------
Method    = 'MD5';
OutFormat = 'hex';
isFile    = false;
isBin     = false;

% Check number and type of inputs: ---------------------------------------------
nOpt = nargin - 1;
Opt  = varargin;
if nOpt == 1 && isa(Opt{1}, 'struct')   % Old style Options as struct:
   Opt  = struct2cell(Opt{1});
   nOpt = numel(Opt);
end

% Loop over strings in the input: ----------------------------------------------
for iOpt = 1:nOpt
   aOpt = Opt{iOpt};
   if ~ischar(aOpt)
      Error_L('BadInputType', '[Opt] must be a struct or chars.');
   end
   
   switch lower(aOpt)
      case 'file'             % Data contains the file name:
         isFile = true;
      case {'bin', 'binary'}  % Just the contents of the data:
         if (isnumeric(Data) || ischar(Data) || islogical(Data) || ...
               myIsString(Data)) == 0 || issparse(Data)
            Error_L('BadDataType', ['[Bin] input needs data type: ', ...
               'numeric, CHAR, LOGICAL, STRING.']);
         end
         isBin = true;
      case 'array'
         isBin = false;      % Is the default already
      case {'asc', 'ascii'}  % 8-bit part of MATLAB CHAR or STRING:
         isBin = true;
         if ischar(Data)
            Data  = uint8(Data);
         elseif myIsString(Data) && numel(Data) == 1
            Data  = uint8(char(Data));
         else
            Error_L('BadDataType', ...
               'ASCII method: Data must be a CHAR or scalar STRING.');
         end
      case 'hex'
         if aOpt(1) == 'H'
            OutFormat = 'HEX';
         else
            OutFormat = 'hex';
         end
      case {'double', 'uint8', 'short', 'base64'}
         OutFormat = lower(aOpt);
      otherwise  % Guess that this is the method:
         Method = upper(aOpt);
   end
end

end

% ******************************************************************************
function FuncKey = ConvertFuncHandle(FuncH)
%   The subfunction ConvertFuncHandle converts function_handles to a struct
%   using the Matlab function FUNCTIONS. The output of this function changes
%   with the Matlab version, such that DataHash(@sin) replies different hashes
%   under Matlab 6.5 and 2009a.
%   An alternative is using the function name and name of the file for
%   function_handles, but this is not unique for nested or anonymous functions.
%   If the MATLABROOT is removed from the file's path, at least the hash of
%   Matlab's toolbox functions is (usually!) not influenced by the version.
%   Finally I'm in doubt if there is a unique method to hash function handles.
%   Please adjust the subfunction ConvertFuncHandles to your needs.

% The Matlab version influences the conversion by FUNCTIONS:
% 1. The format of the struct replied FUNCTIONS is not fixed,
% 2. The full paths of toolbox function e.g. for @mean differ.
FuncKey = functions(FuncH);

% Include modification file time and file size. Suggested by Aslak Grinsted:
if ~isempty(FuncKey.file)
    d = dir(FuncKey.file);
    if ~isempty(d)
        FuncKey.filebytes = d.bytes;
        FuncKey.filedate  = d.datenum;
    end
end

% ALTERNATIVE: Use name and path. The <matlabroot> part of the toolbox functions
% is replaced such that the hash for @mean does not depend on the Matlab
% version.
% Drawbacks: Anonymous functions, nested functions...
% funcStruct = functions(FuncH);
% funcfile   = strrep(funcStruct.file, matlabroot, '<MATLAB>');
% FuncKey    = uint8([funcStruct.function, ' ', funcfile]);

% Finally I'm afraid there is no unique method to get a hash for a function
% handle. Please adjust this conversion to your needs.

end

% ******************************************************************************
function DataBin = ConvertObject(DataObj)
% Convert a user-defined object to a binary stream. There cannot be a unique
% solution, so this part is left for the user...

try    % Perhaps a direct conversion is implemented:
   DataBin = uint8(DataObj);
   
   % Matt Raum had this excellent idea - unfortunately this function is
   % undocumented and might not be supported in te future:
   % DataBin = getByteStreamFromArray(DataObj);
   
catch  % Or perhaps this is better:
   WarnS   = warning('off', 'MATLAB:structOnObject');
   DataBin = struct(DataObj);
   warning(WarnS);
end

end

% ******************************************************************************
function Out = fBase64_enc(In, doPad)
% Encode numeric vector of UINT8 values to base64 string.

B64 = org.apache.commons.codec.binary.Base64;
Out = char(B64.encode(In)).';
if ~doPad
   Out(Out == '=') = [];
end

% Matlab method:
% Pool = [65:90, 97:122, 48:57, 43, 47];  % [0:9, a:z, A:Z, +, /]
% v8   = [128; 64; 32; 16; 8; 4; 2; 1];
% v6   = [32, 16, 8, 4, 2, 1];
%
% In = reshape(In, 1, []);
% X  = rem(floor(bsxfun(@rdivide, In, v8)), 2);
% d6 = rem(numel(X), 6);
% if d6 ~= 0
%    X = [X(:); zeros(6 - d6, 1)];
% end
% Out = char(Pool(1 + v6 * reshape(X, 6, [])));
%
% p = 3 - rem(numel(Out) - 1, 4);
% if doPad && p ~= 0  % Standard base64 string with trailing padding:
%    Out = [Out, repmat('=', 1, p)];
% end

end

% ******************************************************************************
function T = myIsString(S)
% isstring was introduced in R2016:
persistent hasString
if isempty(hasString)
   matlabVer = [100, 1] * sscanf(version, '%d.', 2);
   hasString = (matlabVer >= 901);  % isstring existing since R2016b
end

T = hasString && isstring(S);  % Short-circuting

end

% ******************************************************************************
function R = Version_L()
% The output differs between versions of this function. So give the user a
% chance to recognize the version:
% 1: 01-May-2011, Initial version
% 2: 15-Feb-2015, The number of dimensions is considered in addition.
%    In version 1 these variables had the same hash:
%    zeros(1,1) and zeros(1,1,0), complex(0) and zeros(1,1,0,0)
% 3: 29-Jun-2015, Struct arrays are processed field by field and not element
%    by element, because this is much faster. In consequence the hash value
%    differs, if the input contains a struct.
% 4: 28-Feb-2016 15:20, same output as GetMD5 for MD5 sums. Therefore the
%    dimensions are casted to UINT64 at first.
%    19-May-2018 01:13, STRING type considered.
R.HashVersion = 4;
R.Date        = [2018, 5, 19];

R.HashMethod  = {};
try
   Provider = java.security.Security.getProviders;
   for iProvider = 1:numel(Provider)
      S     = char(Provider(iProvider).getServices);
      Index = strfind(S, 'MessageDigest.');
      for iDigest = 1:length(Index)
         Digest       = strtok(S(Index(iDigest):end));
         Digest       = strrep(Digest, 'MessageDigest.', '');
         R.HashMethod = cat(2, R.HashMethod, {Digest});
      end
   end
catch ME
   fprintf(2, '%s\n', ME.message);
   R.HashMethod = 'error';
end

end

% ******************************************************************************
function Error_L(ID, varargin)

error(['JSimon:', mfilename, ':', ID], ['*** %s: ', varargin{1}], ...
   mfilename, varargin{2:nargin - 1});

end
