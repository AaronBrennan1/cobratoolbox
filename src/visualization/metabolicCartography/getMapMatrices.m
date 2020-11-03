function [map] = getMapMatrices(map)
% Adds 3 matrices to the map structure given as input.
%
% USAGE:
%
%   [map] = getMapMatrices(map)
%
% INPUT:
%   map:        MATLAB structure of the map
%
%                * sID -  Stoichiometric matrix with `rows = MetabolitesID` and
%                  `columns = ReactionsID` in the same order as in the map
%                  structure. Contains `-1` if the metabolite is a
%                  reactant/substract, `+1` if the metabolite is a product
%                  and `0` if it does not participate in the reaction.
%                * sAlias - Stoichiometric matrix with `rows = MetabolitesAlias` and
%                  `columns = ReactionsID` in the same order as in the map
%                  structure. Contains `-1` if the metabolite is a
%                  reactant/substract, `+1` if the metabolite is a product
%                  and `0` if it does not participate in the reaction.
%                * idAlias - Logical matrix with `rows = MetabolitesID` and
%                  `columns = MetabolitesAlias`. Contains `+1` if the
%                  `MetaboliteID` match with the `MetaboliteAlias` and `0`
%                  if it doesn't.
%
% OUTPUT:
%   map:        Updated map structure from the input containing
%               the 3 matrices
%
% .. Author: - N.Sompairac - Institut Curie, Paris, 24/07/2017

% Create a correspondence of species ID and their index for easier access
% during the matrix filling
for ind = 1:length(map.specID)
    specIndexId.(map.specID{ind}) = ind;
end

% Create a correspondence of species alias and their index for easier access
% during the matrix filling
for ind = 1:length(map.molAlias)
    specIndexAlias.(map.molAlias{ind}) = ind;
end

% Initialise the stoechiometric matrices with zeros
sMatrixID = sparse(length(map.specID), length(map.rxnID));
sMatrixAlias = sparse(length(map.molAlias), length(map.rxnID));

allowInconsistency = 0;
% Loop over reactions to fill the matrix
for rxn = 1:length(map.rxnID)
    % Loop over base reactants
    for x = 1:length(map.rxnBaseReactantID{rxn})
        if isfield(specIndexId, map.rxnBaseReactantID{rxn}{x}) || allowInconsistency
            sMatrixID(specIndexId.(map.rxnBaseReactantID{rxn}{x}), rxn) = -1;
        end
        if isfield(specIndexAlias,map.rxnBaseReactantAlias{rxn}{x})
            sMatrixAlias(specIndexAlias.(map.rxnBaseReactantAlias{rxn}{x}), rxn) = -1;
        end
    end
    % Loop over reactants
    for x = 1:length(map.rxnReactantID{rxn})
        if isfield(specIndexId,map.rxnReactantID{rxn}{x})  || allowInconsistency
            sMatrixID(specIndexId.(map.rxnReactantID{rxn}{x}), rxn) = -1;
        end
        if isfield(specIndexAlias,map.rxnReactantAlias{rxn}{x})
            sMatrixAlias(specIndexAlias.(map.rxnReactantAlias{rxn}{x}), rxn) = -1;
        end
    end
    % Loop over base products
    for x = 1:length(map.rxnBaseProductID{rxn})
        if isfield(specIndexId,map.rxnBaseProductID{rxn}{x})  || allowInconsistency
            sMatrixID(specIndexId.(map.rxnBaseProductID{rxn}{x}), rxn) = 1;
        end
        if isfield(specIndexAlias,map.rxnBaseProductAlias{rxn}{x})
            sMatrixAlias(specIndexAlias.(map.rxnBaseProductAlias{rxn}{x}), rxn) = 1;
        end
    end
    % Loop over products
    for x = 1:length(map.rxnProductID{rxn})
        if isfield(specIndexId,map.rxnProductID{rxn}{x})  || allowInconsistency
            sMatrixID(specIndexId.(map.rxnProductID{rxn}{x}), rxn) = 1;
        end
        if isfield(specIndexAlias,map.rxnProductAlias{rxn}{x})
            sMatrixAlias(specIndexAlias.(map.rxnProductAlias{rxn}{x}), rxn) = 1;
        end
    end
end

% Initialise the species ID/Alias matrix with zeros
idAliasMatrix = sparse(length(map.specID), length(map.molAlias));

% Loop over species IDs corresponding to a certain alias
for id = 1:length(map.molID)
    idAliasMatrix(specIndexId.(map.molID{id}), id) = 1;
end

map.sID = sMatrixID;
map.sAlias = sMatrixAlias;
map.idAlias = idAliasMatrix;

