class Ability
    include CanCan::Ability

    def initialize(user)
        # set user to new User if not logged in
        user ||= User.new # i.e., a guest user
    
        # set authorizations for different user roles
        if user.role? :admin
            # they get to do it all
            can :manage, :all

        elsif user.role? :customer
            can :read, Item
            
            can :show, Order do |o|
                o.customer_id == user.id
            end

            can :show, Customer do |c|
                c.id == user.id
            end
            can :update, Customer do |c|
                c.id == user.id
            end

            can :show, User do |u|
                u.id == user.id
            end
            can :update, User do |u|
                u.id == user.id
            end

            can :index, Order
            can :create, Order
            can :checkout, Order
            can :add_to_cart, Order

            can :create, Address
            
            can :show, Address do |a|
                a.customer_id == user.id
            end
            can :update, Address do |a|
                a.customer_id == user.id
            end

            can :index, Address

        elsif user.role? :baker
            can :show, Item
            can :index, Item
            
            can :index, Order

        elsif user.role? :shipper
            can :show, Item
            can :index, Item
            
            can :index, Order
            can :show, Order
            can :show, Address

        else
            can :show, Item
            can :index, Item
            can :create, Customer
        end
        
    end
end
