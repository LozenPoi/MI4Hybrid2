classdef UnPolyModel < PolyModel
    
    % This class describes a (not switched) polynomial model with parameter
    % uncertainty, that is, the coefficient matrix of the model has the form
    % coeffmat = coeffmat_true + delta_coeffmat.
    %
    % Syntax:
    %   sys=UnPolyModel(sys,d_coeffmat);
    %   sys=UnPolyModel(degmat,coeffmat,d_coeffmat);
    %   sys=UnPolyModel(degmat,coeffmat,d_coeffmat,pn_norm,mn_norm);
    %   sys=UnPolyModel(degmat,coeffmat,d_coeffmat,pn_norm,mn_norm,Ep,Em);
    %
    % Author: MI4Hybrid
    % Date: June 5th, 2015
    
    properties(SetAccess=protected)
        % This matrix has the same dimension as the coefficient matrix. It
        % defines the uncertainty limits for the coefficient matrix.
        d_coeffmat
    end
    
    methods
        
        function sys=UnPolyModel(varargin)
            
            % To be able to convert a system model from superclass to subclass.
            if(nargin==2&&isa(varargin{1},'polymodel'))
                sys0=varargin{1};
                degmat=sys0.degmat;
                coeffmat=sys0.coeffmat;
                pn_norm=sys0.pn_norm;
                mn_norm=sys0.mn_norm;
                Ep=sys0.Ep;
                Em=sys0.Em;
                d_coeffmat=varargin{2};
            end
            
            % Obtain basic model information (not for model transfer).
            if(nargin>=3)
                degmat=varargin{1};
                coeffmat=varargin{2};
                d_coeffmat=varargin{3};
            end
            
            % Set up default values if parameters are not specified.
            if(nargin==3)
                pn_norm=zeros(n,1)+inf;
                mn_norm=zeros(n,1)+inf;
                Ep=1;
                Em=1;
            end
            if(nargin==5)
                pn_norm=varargin{4};
                mn_norm=varargin{5};
                Ep=1;
                Em=1;
            end
            if(nargin==7)
                pn_norm=varargin{4};
                mn_norm=varargin{5};
                Ep=varargin{6};
                Em=varargin{7};
            end
            
            % Convert scalars to vectors.
            [m1,n1]=size(coeffmat);
            if(length(d_coeffmat)==1&&length(coeffmat)~=1)
                d_coeffmat=zeros(m1,n1)+d_coeffmat;
                warning(['The uncertainty constraint for the coefficient'...
                ' matrix is a scalar, converted to an array with the same entries.']);
            end
            
            % Check if the uncertainty is consistent with coeffmat.
            [m2,n2]=size(d_coeffmat);
            if(m1~=m2||n1~=n2)
                error(['The uncertainty constraint for the coefficient '...
                'matrix should have the same dimension as the coefficient matrix.']);
            end
            
            % Call the constructor of the super class.
            sys@PolyModel(degmat,coeffmat,pn_norm,mn_norm,Ep,Em);
            
            % Assign the uncertainty constraints.
            sys.d_coeffmat=d_coeffmat;
            
        end
        
    end
    
end