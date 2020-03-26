function [betweenEdges] = edgesBetween(edges)
betweenEdges = (edges(1:end-1)+(diff(edges)./2))';