function [meta] = PrepareMetadata(dataset,callbackresult)
%PREPAREMETADATA Prepare SpikeGLX metadata for exported dataset and its callbackresult
%   Detailed explanation goes here

meta=[];
%% Prepare experimental metadata
exmeta = [];
if (~isempty(dataset) && isfield(dataset,'ex'))
    exmeta = NeuroAnalysis.Base.EvalFun(['NeuroAnalysis.',dataset.ex.sourceformat,'.PrepareMetadata'], ...
        {dataset,callbackresult});
    if isfield(exmeta,'status') && ~exmeta.status
        exmeta = [];
    end
    if isfield(exmeta,'sourceformat')
        exmeta = rmfield(exmeta,'sourceformat');
    end
    if isfield(exmeta,'filename')
        exmeta = rmfield(exmeta,'filename');
    end
    if isfield(exmeta,'files')
        exmeta = rmfield(exmeta,'files');
    end
end
%% Prepare SpikeGLX metadata
disp('Preparing SpikeGLX Metadata:    ...');
spikeglxmeta = [];
if ~isempty(dataset)
    spikeglxmeta.files={dataset.filepath};
    [~, spikeglxmeta.filename, ~] = fileparts(dataset.filepath);
    spikeglxmeta.sourceformat = dataset.sourceformat;
end
%% Get Callback metadata
callbackmeta = [];
if(~isempty(callbackresult) && isfield(callbackresult,'result')) && isstruct(callbackresult.result)
    callbackmeta = callbackresult.result;
end
%% Combine metadata
meta = NeuroAnalysis.Base.mergestruct(exmeta,spikeglxmeta);
if (~isempty(meta) && ~isempty(fieldnames(meta)))
    if (~isempty(callbackmeta) && ~isempty(fieldnames(callbackmeta)))
        meta.result = callbackmeta;
    end
end
disp('Preparing SpikeGLX Metadata:    Done.');
end

