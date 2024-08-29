function initCobrarrow()
% Display MATLAB version
ver = version;
fprintf('MATLAB Version: %s\n', ver);

% Check if Python is installed and display details
pyEnvInfo = pyenv;

if isempty(pyEnvInfo.Executable)
    showInstruction();
else
    fprintf('Python is installed. Version: ');
    disp(pyEnvInfo.Version);
    fprintf('Python Executable: \n');
    disp(pyEnvInfo.Executable);

    try
        py.math.sqrt(16); % test Python version compatibility

        % Get the current directory where the MATLAB script is located
        currentFile = mfilename('fullpath');
        currentDir = fileparts(currentFile);
        
        % Construct the full path to the requirements.txt file
        requirementsPath = fullfile(currentDir, 'requirements.txt');

        % Use python -m pip install to ensure pip is invoked correctly
        cmd = sprintf('"%s" -m pip install -r "%s"', pyEnvInfo.Executable, requirementsPath);
        status = system(cmd);

        if status == 0
            disp('Packages installed successfully.');
        else
            disp('Failed to install packages.');
        end

        fprintf("\nNow you can use the COBRArrow API in MATLAB.\n\n");
    catch ME
        showInstruction();
        error('Failed to use Python. Please check the Python installation.\n');
    end
end
end

function showInstruction()
    versionLink = 'https://uk.mathworks.com/support/requirements/python-compatibility.html?s_tid=srchtitle_site_search_1_python%20compatibility';
    versionLabel = 'Versions of Python Compatible with MATLAB';
    configLink = 'https://uk.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html';
    configLabel = 'Configure Your System to Use Python';

    fprintf('Python is not installed or not set up in MATLAB.\n');
    fprintf('Please install the correct version of Python according to ');
    fprintf('<a href="%s">%s</a>. \n', versionLink, versionLabel);
    fprintf('Please refer to <a href="%s">%s</a> to config Python in MATLAB. \n', configLink,configLabel);
end