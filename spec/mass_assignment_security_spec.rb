require 'spec_helper'

class AlfredModel
  include ActiveModel::MassAssignmentSecurity
  extend Alfred::ActiveModel::MassAssignmentSecurity
  attr_accessor :a, :b, :c, :d, :e, :f
end

describe Alfred::ActiveModel::MassAssignmentSecurity::ClassMethods do

  describe "accessible" do

    describe "create attr_accessible" do
      it "add's attr_accessible with default role" do
        class AAModel < AlfredModel
          alfred_accessible :a, :b
        end
        AAModel.accessible_attributes.should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b].map(&:to_s)))
      end

      it "appends attr_accessible to default role" do
        class ABModel < AlfredModel
          alfred_accessible :a, :b
          alfred_accessible :c, :d
        end
        ABModel.accessible_attributes.should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b, :c, :d].map(&:to_s)))
      end

      it "add's attr_accessible with custom role" do
        class ACModel < AlfredModel
          alfred_accessible :a, :b, as: :custom
        end
        ACModel.accessible_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b].map(&:to_s)))
      end

      it "appends attr_accessible to custom role" do
        class ADModel < AlfredModel
          alfred_accessible :a, :b, as: :custom
          alfred_accessible :c, :d, as: :custom
        end
        ADModel.accessible_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b, :c, :d].map(&:to_s)))
      end

      it "add's attr_accessible to action" do
        class AEModel < AlfredModel
          alfred_accessible :a, :b, on: :create
        end
        AEModel.accessible_attributes(:default_create).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b].map(&:to_s)))
      end

      it "appends attr_accessible with custom role to event" do
        class AFModel < AlfredModel
          alfred_accessible :a, :b, as: :custom, on: :create
        end
        AFModel.accessible_attributes(:custom_create).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b].map(&:to_s)))
      end
    end

    describe "inheritance" do
      it "inherits from default role" do
        class AGModel < AlfredModel
          alfred_accessible :a, :b
          alfred_accessible :c, :d, as: :custom
          alfred_accessible :e, :f, as: :custom2
        end
        AGModel.accessible_attributes.should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b].map(&:to_s)))
        AGModel.accessible_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b, :c, :d].map(&:to_s)))
        AGModel.accessible_attributes(:custom2).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b, :e, :f].map(&:to_s)))
      end

      it "inherits from custom role" do
        class AHModel < AlfredModel
          alfred_accessible :a, :b
          alfred_accessible :c, :d, as: :custom
          alfred_accessible :e, :f, as: :custom2, inherit: :custom
          alfred_accessible :e, :f, as: :custom2, inherit: :custom
        end
        AHModel.accessible_attributes.should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b].map(&:to_s)))
        AHModel.accessible_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b, :c, :d].map(&:to_s)))
        AHModel.accessible_attributes(:custom2).should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:a, :b, :c, :d, :e, :f].map(&:to_s)))
      end
    end

    describe "auto password confirmation" do
      it "add's automatically password_confirmation if enabled" do
        Alfred.auto_password_confirmation = true
        class AIModel < AlfredModel
          attr_accessor :password, :password_confirmation
          alfred_accessible :password
        end
        AIModel.accessible_attributes.should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:password, :password_confirmation].map(&:to_s)))
      end

      it "not add's automatically password_confirmation if disabled" do
        Alfred.auto_password_confirmation = false
        class AJModel < AlfredModel
          attr_accessor :password, :password_confirmation
          alfred_accessible :password
        end
        AJModel.accessible_attributes.should eq(ActiveModel::MassAssignmentSecurity::WhiteList.new([:password].map(&:to_s)))
      end
    end

  end

  describe "protected" do

     describe "create attr_protected" do
       it "add's attr_protected with default role" do
         class PAModel < AlfredModel
           alfred_protected :a, :b
         end
         PAModel.protected_attributes.should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b].map(&:to_s)))
       end

       it "appends attr_protected to default role" do
         class PBModel < AlfredModel
           alfred_protected :a, :b
           alfred_protected :c, :d
         end
         PBModel.protected_attributes.should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b, :c, :d].map(&:to_s)))
       end

       it "add's attr_protected with custom role" do
         class PCModel < AlfredModel
           alfred_protected :a, :b, as: :custom
         end
         PCModel.protected_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b].map(&:to_s)))
       end

       it "appends attr_protected to custom role" do
         class PDModel < AlfredModel
           alfred_protected :a, :b, as: :custom
           alfred_protected :c, :d, as: :custom
         end
         PDModel.protected_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b, :c, :d].map(&:to_s)))
       end

       it "add's attr_protected to action" do
         class PEModel < AlfredModel
           alfred_protected :a, :b, on: :create
         end
         PEModel.protected_attributes(:default_create).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b].map(&:to_s)))
       end

       it "appends attr_protected with custom role to action" do
         class PFModel < AlfredModel
           alfred_protected :a, :b, as: :custom, on: :create
         end
         PFModel.protected_attributes(:custom_create).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b].map(&:to_s)))
       end
     end

     describe "inheritance" do
       it "inherits from default role" do
         class PGModel < AlfredModel
           alfred_protected :a, :b
           alfred_protected :c, :d, as: :custom
           alfred_protected :e, :f, as: :custom2
         end
         PGModel.protected_attributes.should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b].map(&:to_s)))
         PGModel.protected_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b, :c, :d].map(&:to_s)))
         PGModel.protected_attributes(:custom2).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b, :e, :f].map(&:to_s)))
       end

       it "inherits from custom role" do
         class PHModel < AlfredModel
           alfred_protected :a, :b
           alfred_protected :c, :d, as: :custom
           alfred_protected :e, :f, as: :custom2, inherit: :custom
         end
         PHModel.protected_attributes.should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b].map(&:to_s)))
         PHModel.protected_attributes(:custom).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b, :c, :d].map(&:to_s)))
         PHModel.protected_attributes(:custom2).should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:a, :b, :c, :d, :e, :f].map(&:to_s)))
       end
     end

     describe "auto password confirmation" do
       it "add's automatically password_confirmation if enabled" do
         Alfred.auto_password_confirmation = true
         class PIModel < AlfredModel
           attr_accessor :password, :password_confirmation
           alfred_protected :password
         end
         PIModel.protected_attributes.should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:password, :password_confirmation].map(&:to_s)))
       end

       it "not add's automatically password_confirmation if disabled" do
         Alfred.auto_password_confirmation = false
         class PJModel < AlfredModel
           attr_accessor :password, :password_confirmation
           alfred_protected :password
         end
         PJModel.protected_attributes.should eq(ActiveModel::MassAssignmentSecurity::BlackList.new([:password].map(&:to_s)))
       end
     end

   end

end
