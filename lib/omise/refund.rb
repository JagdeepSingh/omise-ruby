require "omise/object"
require "omise/search_scope"

module Omise
  # A {Refund} represents the return of a payment that has originally been made
  # through one of the payment methods available in the country where you're
  # using Omise. Note that not all payment methods supports refunds.
  #
  # See https://www.omise.co/refunds-api for more information regarding
  # the refund attributes, the available endpoints and the different parameters
  # each endpoint accepts.
  #
  class Refund < OmiseObject
    self.endpoint = "/refunds"

    # Initializes a search scope that when executed will search through your
    # account's refunds.
    #
    # Example:
    #
    #     results = Omise::Refund.search
    #       .filter(card_last_digits: "4242")
    #       .execute
    #
    # Returns a {SearchScope} instance.
    #
    def self.search
      SearchScope.new(:refund)
    end

    def self.list(attributes = {})
      List.new resource(location, attributes).get(attributes)
    end

    # Reloads an existing refund.
    #
    # Calling this method will issue a single HTTP request:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID/refunds/REFUND_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     refund = charge.refunds.retrieve(refund_id)
    #     refund.reload
    #
    # Returns the same {Refund} instance with its attributes updated if
    # successful and raises an {Error} if the request fails.
    #
    def reload(attributes = {})
      assign_attributes resource(attributes).get(attributes)
    end

    # Typecasts or expands the charge attached to a refund.
    #
    # Calling this method may issue a single HTTP request if the refund was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/charges/CHARGE_ID
    #
    # Example:
    #
    #     charge = Omise::Charge.retrieve(charge_id)
    #     refund = charge.refunds.retrieve(refund_id)
    #     charge = refund.charge
    #
    # Returns a new {Charge} instance if successful or raises an {Error} if the
    # request fails.
    #
    def charge(options = {})
      if !defined?(Charge)
        require "omise/charge"
      end

      expand_attribute Charge, "charge", options
    end

    # Typecasts or expands the transaction attached to a refund.
    #
    # Calling this method may issue a single HTTP request if the refund was
    # originally not fetched with the `expand` option:
    #
    #   - GET https://api.omise.co/transactions/TRANSACTION_ID
    #
    # Example:
    #
    #     charge       = Omise::Charge.retrieve(charge_id)
    #     refund       = charge.refunds.retrieve(refund_id)
    #     transactions = refund.transactions
    #
    # Returns a new {Transaction} instance if successful or raises an {Error}
    # if the request fails.
    #
    def transaction(options = {})
      if !defined?(Transaction)
        require "omise/transaction"
      end

      expand_attribute Transaction, "transaction", options
    end
  end
end
