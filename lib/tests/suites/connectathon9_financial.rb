module Crucible
  module Tests
    class FinancialTest < BaseSuite

      def id
        'Connectathon9Financial'
      end

      def description
        'Connectathon 9 Financial Tests'
      end

      def setup
        @resources = Crucible::Generator::Resources.new

        @simple = @resources.simple_claim
        @simple.xmlId = nil # clear the identifier, in case the server checks for duplicates
        @simple.identifier = nil # clear the identifier, in case the server checks for duplicates

        @average = @resources.average_claim
        @average.xmlId = nil # clear the identifier, in case the server checks for duplicates
        @average.identifier = nil # clear the identifier, in case the server checks for duplicates
      end

      def teardown
        @client.destroy(FHIR::Claim, @simple_id) if !@simple_id.nil?
        @client.destroy(FHIR::ClaimResponse, @simple_response_id) if !@simple_response_id.nil?
        @client.destroy(FHIR::Claim, @average_id) if !@average_id.nil?
        @client.destroy(FHIR::ClaimResponse, @average_response_id) if !@average_response_id.nil?
      end

      #
      # Test if we can create a new Claim.
      #
      test 'C9F_1A','Register a simple claim' do
        metadata {
          links "#{REST_SPEC_LINK}#create"
          links "#{BASE_SPEC_LINK}/claim.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'Claim', methods: ['create']
          validates resource: 'Claim', methods: ['create']
        }

        reply = @client.create @simple
        @simple_id = reply.id
        assert_response_ok(reply)

        if !reply.resource.nil?
          temp = reply.resource.xmlId
          reply.resource.xmlId = nil
          warning { assert @simple.equals?(reply.resource), 'The server did not correctly preserve the Claim data.' }
          reply.resource.xmlId = temp
        end

        warning { assert_valid_resource_content_type_present(reply) }
        warning { assert_last_modified_present(reply) }
        warning { assert_valid_content_location_present(reply) }
      end

      #
      # Test if we can create a different new Claim.
      #
      test 'C9F_1B','Register an average claim' do
        metadata {
          links "#{REST_SPEC_LINK}#create"
          links "#{BASE_SPEC_LINK}/claim.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'Claim', methods: ['create']
          validates resource: 'Claim', methods: ['create']
        }

        reply = @client.create @average
        @average_id = reply.id

        assert_response_ok(reply)

        if !reply.resource.nil?
          temp = reply.resource.xmlId
          reply.resource.xmlId = nil
          warning { assert @average.equals?(reply.resource), 'The server did not correctly preserve the Claim data.' }
          reply.resource.xmlId = temp
        end

        warning { assert_valid_resource_content_type_present(reply) }
        warning { assert_last_modified_present(reply) }
        warning { assert_valid_content_location_present(reply) }
      end

      # ------------------------------------------------------------------------------

      #
      # Search for a ClaimResponse by simple claim
      #
      test 'C9F_2A_request', 'Search ClaimResponse by simple claim ID' do
        metadata {
          links "#{REST_SPEC_LINK}#search"
          links "#{BASE_SPEC_LINK}/claimresponse.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'ClaimResponse', methods: ['search']
          validates resource: 'ClaimResponse', methods: ['search']
        }
        skip unless @simple_id

        search_string = @simple_id
        search_regex = Regexp.new(search_string)

        options = {
          :search => {
            :flag => true,
            :compartment => nil,
            :parameters => {
              'request' => search_string
            }
          }
        }
        @client.use_format_param = true
        reply = @client.search(FHIR::ClaimResponse, options)
        assert_response_ok(reply)
        assert_bundle_response(reply)
        assert (reply.resource.total > 0), 'The server did not report any results.'
      end

      #
      # Search for a ClaimResponse by simple claim
      #
      test 'C9F_2A_text', 'Search ClaimResponse by simple claim ID in the text' do
        metadata {
          links "#{REST_SPEC_LINK}#search"
          links "#{BASE_SPEC_LINK}/claimresponse.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'ClaimResponse', methods: ['search']
          validates resource: 'ClaimResponse', methods: ['search']
        }
        skip unless @simple_id

        search_string = @simple_id
        search_regex = Regexp.new(search_string)

        options = {
          :search => {
            :flag => true,
            :compartment => nil,
            :parameters => {
              '_text' => search_string
            }
          }
        }
        @client.use_format_param = true
        reply = @client.search(FHIR::ClaimResponse, options)
        assert_response_ok(reply)
        assert_bundle_response(reply)
        assert (reply.resource.total > 0), 'The server did not report any results.'
      end

      #
      # Search for a ClaimResponse by simple claim
      #
      test 'C9F_2A_content', 'Search ClaimResponse by simple claim ID in the content' do
        metadata {
          links "#{REST_SPEC_LINK}#search"
          links "#{BASE_SPEC_LINK}/claimresponse.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'ClaimResponse', methods: ['search']
          validates resource: 'ClaimResponse', methods: ['search']
        }
        skip unless @simple_id

        search_string = @simple_id
        search_regex = Regexp.new(search_string)

        options = {
          :search => {
            :flag => true,
            :compartment => nil,
            :parameters => {
              '_content' => search_string
            }
          }
        }
        @client.use_format_param = true
        reply = @client.search(FHIR::ClaimResponse, options)
        assert_response_ok(reply)
        assert_bundle_response(reply)
        assert (reply.resource.total > 0), 'The server did not report any results.'
      end

      # ------------------------------------------------------------------------------

      #
      # Search for a ClaimResponse by average claim
      #
      test 'C9F_2B_request', 'Search ClaimResponse by average claim ID' do
        metadata {
          links "#{REST_SPEC_LINK}#search"
          links "#{BASE_SPEC_LINK}/claimresponse.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'ClaimResponse', methods: ['search']
          validates resource: 'ClaimResponse', methods: ['search']
        }
        skip unless @average_id

        search_string = @average_id
        search_regex = Regexp.new(search_string)

        options = {
          :search => {
            :flag => true,
            :compartment => nil,
            :parameters => {
              'request' => search_string
            }
          }
        }
        @client.use_format_param = true
        reply = @client.search(FHIR::ClaimResponse, options)
        assert_response_ok(reply)
        assert_bundle_response(reply)
        assert (reply.resource.total > 0), 'The server did not report any results.'
      end

      #
      # Search for a ClaimResponse by average claim
      #
      test 'C9F_2B_text', 'Search ClaimResponse by average claim ID in the text' do
        metadata {
          links "#{REST_SPEC_LINK}#search"
          links "#{BASE_SPEC_LINK}/claimresponse.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'ClaimResponse', methods: ['search']
          validates resource: 'ClaimResponse', methods: ['search']
        }
        skip unless @average_id

        search_string = @average_id
        search_regex = Regexp.new(search_string)

        options = {
          :search => {
            :flag => true,
            :compartment => nil,
            :parameters => {
              '_text' => search_string
            }
          }
        }
        @client.use_format_param = true
        reply = @client.search(FHIR::ClaimResponse, options)
        assert_response_ok(reply)
        assert_bundle_response(reply)
        assert (reply.resource.total > 0), 'The server did not report any results.'
      end

      #
      # Search for a ClaimResponse by average claim
      #
      test 'C9F_2B_content', 'Search ClaimResponse by average claim ID in the content' do
        metadata {
          links "#{REST_SPEC_LINK}#search"
          links "#{BASE_SPEC_LINK}/claimresponse.html"
          links 'http://wiki.hl7.org/index.php?title=Connectathon9_Financial#Submit_a_Claim_via_REST.2C_Retrieve_a_ClaimResponse'
          requires resource: 'ClaimResponse', methods: ['search']
          validates resource: 'ClaimResponse', methods: ['search']
        }
        skip unless @average_id

        search_string = @average_id
        search_regex = Regexp.new(search_string)

        options = {
          :search => {
            :flag => true,
            :compartment => nil,
            :parameters => {
              '_content' => search_string
            }
          }
        }
        @client.use_format_param = true
        reply = @client.search(FHIR::ClaimResponse, options)
        assert_response_ok(reply)
        assert_bundle_response(reply)
        assert (reply.resource.total > 0), 'The server did not report any results.'
      end

    end
  end
end
