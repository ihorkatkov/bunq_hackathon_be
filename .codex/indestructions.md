# Elixir Application Structure

<rule>
name: elixir_application_structure
description: Best practices for structuring and organizing Elixir applications
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Application Structure Best Practices

      ## Project Organization
      - Follow standard Mix project directory structure
      - Keep the `lib/` directory clean and well-organized
      - Group related modules into subdirectories by domain or feature
      - Use contexts to isolate different parts of your application
      
      ## Application Design
      - Use bounded contexts to isolate domain logic
      - Design clear boundaries between application components
      - Use dependency injection for configurable components
      - Maintain consistent layer structure (persistence, domain logic, API)
      
      ## Configuration
      - Use configuration properly with environment-specific settings
      - Don't hardcode configuration values in modules
      - Use Application environment or runtime configuration when appropriate
      - Consider using config providers for production configuration
      
      ## OTP Applications
      - Design proper supervision trees
      - Use the Application behaviour to start your applications
      - Define clear startup phases in application initialization
      - Handle application shutdown gracefully
      
      ## Code Organization
      - Separate interface and implementation
      - Group related functionality in contexts
      - Place domain logic in core modules
      - Use behaviors and protocols to define interfaces
      
      ## Dependency Management
      - Keep dependencies minimal and well-justified
      - Specify exact version requirements for dependencies
      - Use umbrella projects for large, complex applications
      - Consider creating internal libraries for shared functionality

examples:
  - input: |
      # Poor structure with everything at top level
      defmodule MyApp do
        def start(_type, _args) do
          # ...
        end
      end
      
      defmodule UserRepo do
        # User database functions
      end
      
      defmodule UserController do
        # User API controller
      end
      
      defmodule OrderProcessor do
        # Order processing logic
      end
      
      defmodule NotificationSender do
        # Notification logic
      end
    output: |
      # Well-structured application with contexts
      defmodule MyApp do
        @moduledoc """
        Main application module for MyApp.
        """
        use Application
        
        def start(_type, _args) do
          children = [
            MyApp.Repo,
            {Phoenix.PubSub, name: MyApp.PubSub},
            MyApp.Endpoint,
            {MyApp.Orders.Supervisor, []}
          ]
          
          opts = [strategy: :one_for_one, name: MyApp.Supervisor]
          Supervisor.start_link(children, opts)
        end
      end
      
      # /lib/my_app/accounts/accounts.ex
      defmodule MyApp.Accounts do
        @moduledoc """
        The Accounts context.
        Handles user management, authentication, and permissions.
        """
        
        alias MyApp.Accounts.User
        alias MyApp.Repo
        
        @doc """
        Returns the list of users.
        """
        def list_users do
          Repo.all(User)
        end
        
        # More user-related public functions...
      end
      
      # /lib/my_app/accounts/user.ex
      defmodule MyApp.Accounts.User do
        @moduledoc """
        The User schema and validation logic.
        """
        use Ecto.Schema
        import Ecto.Changeset
        
        schema "users" do
          field :email, :string
          field :name, :string
          # ...
          
          timestamps()
        end
        
        # Changeset functions and validations...
      end
      
      # /lib/my_app/orders/orders.ex
      defmodule MyApp.Orders do
        @moduledoc """
        The Orders context.
        Handles order processing, fulfillment, and related operations.
        """
        
        # Public API for orders...
      end
      
      # /lib/my_app/notifications/notifications.ex
      defmodule MyApp.Notifications do
        @moduledoc """
        The Notifications context.
        Handles sending notifications via various channels.
        """
        
        # Public API for notifications...
      end
  
  - input: |
      # Configuration sprinkled throughout code
      defmodule MyApp.EmailSender do
        def send_email(to, subject, body) do
          smpt_server = "smtp.mycompany.com"
          port = 587
          username = "system@mycompany.com"
          password = "secretpassword"
          
          # Email sending logic...
        end
      end
    output: |
      # Config file: config/config.exs
      # use Mix.Config  # For Elixir < 1.9
      import Config    # For Elixir >= 1.9
      
      config :my_app, MyApp.Mailer,
        adapter: Bamboo.SMTPAdapter,
        server: "smtp.mycompany.com",
        port: 587,
        username: "system@mycompany.com",
        password: {:system, "SMTP_PASSWORD"}  # Will be fetched from environment variable
      
      import_config "#{config_env()}.exs"
      
      # Development config: config/dev.exs
      import Config
      
      config :my_app, MyApp.Mailer,
        adapter: Bamboo.LocalAdapter  # Use local adapter for development
      
      # App code
      defmodule MyApp.Mailer do
        @moduledoc """
        Provides email sending functionality.
        """
        use Bamboo.Mailer, otp_app: :my_app
      end
      
      defmodule MyApp.Email do
        @moduledoc """
        Defines email templates and composition logic.
        """
        import Bamboo.Email
        
        def welcome_email(user) do
          new_email()
          |> to(user.email)
          |> from("welcome@mycompany.com")
          |> subject("Welcome to MyApp")
          |> text_body("Welcome to MyApp, #{user.name}!")
        end
      end
      
      defmodule MyApp.Accounts do
        alias MyApp.{Email, Mailer}
        
        def create_user(attrs) do
          # Create user logic...
          
          # Send welcome email
          user
          |> Email.welcome_email()
          |> Mailer.deliver_later()
          
          {:ok, user}
        end
      end

metadata:
  priority: high
  version: 1.0
</rule> 
<rule>
name: elixir_complete_implementation
description: Standards for ensuring complete implementation of code and tests
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"
  - type: directory
    exclude_patterns:
      - "^\\.git"
      - "^_build"
      - "^deps"

actions:
  - type: suggest
    message: |
      # Code Completeness Standards

      ## Core Requirements
      - Never leave incomplete or partially implemented code
      - Never commit code without corresponding tests
      - All implementation paths must be handled
      - All edge cases must be covered in tests

      ## Implementation Process
      1. Before starting implementation:
         - Fully understand the requirements
         - Plan all edge cases
         - Design test scenarios
      
      2. During implementation:
         - Complete one functional unit at a time
         - Write tests alongside the implementation
         - If stuck, immediately seek user guidance
         - Do not proceed with partial solutions
      
      3. Before considering implementation complete:
         - All planned test cases are implemented
         - All functions have documentation
         - All edge cases are handled
         - All compiler warnings are addressed

      ## When Stuck
      1. Stop implementation immediately
      2. Document current progress
      3. List specific challenges or unknowns
      4. Ask user for guidance with:
         - Current implementation state
         - Specific questions about unclear parts
         - Proposed approaches to consider

      ## Exceptions
      - None. All code must be complete with tests

examples:
  - input: |
      # Bad: Incomplete implementation
      defmodule UserManager do
        def create_user(params) do
          # TODO: Add validation
          # TODO: Handle errors
          User.changeset(params)
          |> Repo.insert()
        end
        
        # TODO: Implement update_user
        
        def delete_user(id) do
          # Need to handle cascading deletes
          Repo.get(User, id)
          |> Repo.delete()
        end
      end
    output: |
      """
      I need guidance before proceeding with the implementation:

      1. Current status:
         - Basic create_user structure is in place
         - delete_user needs cascade handling
         - update_user is not implemented

      2. Specific questions:
         - What validation rules should be applied?
         - How should we handle cascading deletes?
         - What fields should be updatable?

      3. Proposed approach:
         - Add validation using Ecto.Changeset
         - Implement soft deletes
         - Add update with permitted fields

      How would you like me to proceed with the implementation?
      """

      # Good: Complete implementation after guidance
      defmodule UserManager do
        @moduledoc """
        Handles user management operations with complete validation and error handling.
        """

        @doc """
        Creates a new user with validation and error handling.
        
        ## Examples
            
            iex> create_user(%{email: "user@example.com", name: "John"})
            {:ok, %User{}}
            
            iex> create_user(%{email: "invalid"})
            {:error, %Ecto.Changeset{}}
        """
        def create_user(params) do
          %User{}
          |> User.changeset(params)
          |> validate_unique_email()
          |> Repo.insert()
          |> broadcast_user_created()
        end

        @doc """
        Updates a user with validation and error handling.
        """
        def update_user(user, params) do
          user
          |> User.changeset(params)
          |> validate_unique_email()
          |> Repo.update()
          |> broadcast_user_updated()
        end

        @doc """
        Soft deletes a user and handles all cascading operations.
        """
        def delete_user(id) do
          with {:ok, user} <- get_user(id),
               :ok <- validate_deletable(user),
               {:ok, _} <- handle_cascade_deletes(user),
               {:ok, deleted} <- do_soft_delete(user) do
            broadcast_user_deleted(deleted)
          end
        end

        # Private functions with complete implementation...
      end

      # Complete test module
      defmodule UserManagerTest do
        use ExUnit.Case
        
        describe "create_user/1" do
          test "creates user with valid params" do
            # Complete test implementation
          end

          test "handles invalid params" do
            # Complete test implementation
          end

          test "validates unique email" do
            # Complete test implementation
          end
        end

        # Complete test cases for all functions...
      end

metadata:
  priority: high
  version: 1.0
</rule>
# Elixir Documentation Practices

<rule>
name: elixir_documentation
description: Best practices for writing effective documentation in Elixir code
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Documentation Best Practices

      ## Module Documentation
      - Always include a `@moduledoc` attribute with clear description of the module's purpose
      - Structure module docs with markdown headings for better readability
      - Include examples of common usage patterns
      - Document any behaviors the module implements
      - For large modules, add a table of contents
      
      ## Function Documentation
      - Document all public functions with `@doc` attributes
      - Include information about:
        - What the function does
        - Parameter descriptions and expected types
        - Return value description and type
        - Possible errors or exceptions
        - Usage examples
      - Use backticks for code elements: `variable_name`, `function_name/arity`
      
      ## Type Documentation
      - Use `@typedoc` to explain complex or non-obvious types
      - Document all public type definitions
      
      ## Code Examples
      - Include practical examples in documentation
      - Use doctests with `iex>` prompts to provide testable examples:
        ```elixir
        @doc """
        Adds two numbers.
        
        ## Examples
            
            iex> Calculator.add(2, 3)
            5
        """
        ```
      
      ## Documentation Format
      - Use markdown formatting for rich documentation
      - Add headers, lists, and code blocks to structure information
      - Use backticks for inline code and triple backticks for code blocks
      - Keep line length at a reasonable width (recommended: 80-100 characters)
      
      ## Specialized Documentation
      - Add `@deprecated` tags with migration information for deprecated functions
      - Include `@since` tags when version history is important
      - Use `@see` references to link to related functions or modules

examples:
  - input: |
      defmodule MyApp.User do
        def create(attrs) do
          # Implementation
        end
        
        def update(user, attrs) do
          # Implementation
        end
      end
    output: |
      defmodule MyApp.User do
        @moduledoc """
        Handles user-related operations including creation, updates, and queries.
        
        This module provides a complete API for managing user accounts in the system.
        """
        
        @doc """
        Creates a new user with the given attributes.
        
        ## Parameters
          - attrs: Map containing user attributes
        
        ## Returns
          - `{:ok, user}` on success
          - `{:error, changeset}` on validation failure
        
        ## Examples
        
            iex> MyApp.User.create(%{name: "John", email: "john@example.com"})
            {:ok, %User{name: "John", email: "john@example.com"}}
        """
        def create(attrs) do
          # Implementation
        end
        
        @doc """
        Updates an existing user with the provided attributes.
        
        ## Parameters
          - user: The user struct to update
          - attrs: Map containing updated user attributes
        
        ## Returns
          - `{:ok, user}` on success
          - `{:error, changeset}` on validation failure
        
        ## Examples
        
            iex> MyApp.User.update(user, %{name: "New Name"})
            {:ok, %User{name: "New Name", email: "john@example.com"}}
        """
        def update(user, attrs) do
          # Implementation
        end
      end

metadata:
  priority: high
  version: 1.0
</rule> 
# Elixir Error Handling

<rule>
name: elixir_error_handling
description: Best practices for handling errors and exceptions in Elixir
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Error Handling Best Practices

      ## Return Values vs Exceptions
      - Use `{:ok, result}` and `{:error, reason}` tuples for expected error cases
      - Use exceptions only for exceptional, unexpected situations
      - Provide both bang (`!`) and non-bang versions of functions when appropriate
      - Document error return values in function specifications
      
      ## Error Tuples
      - Use standardized error tuples: `{:error, reason}` or `{:error, type, reason}`
      - Make error reasons descriptive and actionable
      - Consider including additional context in error tuples for complex operations
      - Use atoms for error types to allow pattern matching
      
      ## With Statement
      - Use `with` for sequences of operations that can fail
      - Handle errors explicitly in the `else` clause
      - Avoid deeply nested `with` statements
      - Return consistent error structures from `with` expressions
      
      ## Try/Rescue
      - Use `try/rescue` sparingly, primarily when working with external code
      - Rescue specific exceptions rather than catching all exceptions
      - Re-raise exceptions with additional context when appropriate
      - Clean up resources with `after` clause regardless of exceptions
      
      ## Custom Exceptions
      - Define custom exceptions for application-specific error conditions
      - Use `defexception` to create structured exception types
      - Include helpful message and context in custom exceptions
      - Implement `Exception` behavior for custom exception types
      
      ## Process Failures
      - Design processes to fail fast and restart cleanly
      - Use supervision trees to handle process failures
      - Consider using `handle_info/2` to catch specific exit signals
      - Log errors appropriately before crashing

examples:
  - input: |
      def fetch_user(id) do
        case Repo.get(User, id) do
          nil -> raise "User not found"
          user -> user
        end
      end
    output: |
      def fetch_user(id) do
        case Repo.get(User, id) do
          nil -> {:error, :not_found}
          user -> {:ok, user}
        end
      end
      
      def fetch_user!(id) do
        case Repo.get(User, id) do
          nil -> raise UserNotFoundError, "User with ID #{id} not found"
          user -> user
        end
      end
      
      defmodule UserNotFoundError do
        defexception message: "User not found"
      end
  
  - input: |
      def process_file(path) do
        data = File.read(path)
        if elem(data, 0) == :ok do
          process_data(elem(data, 1))
        else
          raise "Couldn't read file"
        end
      end
    output: |
      def process_file(path) do
        with {:ok, data} <- File.read(path),
             {:ok, result} <- process_data(data) do
          {:ok, result}
        else
          {:error, :enoent} -> 
            {:error, :file_not_found, "File does not exist at #{path}"}
          {:error, reason} -> 
            {:error, :file_error, reason}
          {:error, :processing, reason} -> 
            {:error, :processing_failed, reason}
        end
      end
      
      def process_data(data) do
        # Process data and return {:ok, result} or {:error, :processing, reason}
      end

metadata:
  priority: high
  version: 1.0
</rule> 
# Elixir Module Structure

<rule>
name: elixir_module_structure
description: Best practices for structuring Elixir modules in a clean, maintainable way
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Module Structure Best Practices

      ## Module Organization
      - Group related functions together
      - Organize code in the following order:
        1. Module attributes and constants
        2. Public API functions
        3. Private implementation functions
        4. Callback implementations
        5. Helper functions
      
      ## Module Size
      - Keep modules focused on a single responsibility
      - Consider splitting large modules into smaller, more focused ones
      - Use composition over inheritance to share functionality
      
      ## Imports and Aliases
      - Place all `import`, `alias`, and `require` statements at the top of the module
      - Only import or alias what you need, avoid wildcard imports
      - Group related imports/aliases together
      - Prefer aliases over imports when possible
      
      ## Function Definitions
      - Keep functions short and focused on a single task
      - Avoid deeply nested functions
      - Place related function clauses together
      - Use function clauses and pattern matching instead of conditionals when possible
      
      ## Documentation
      - Document all public functions with `@doc` attributes
      - Use `@moduledoc` to describe the module's purpose
      - Add `@typedoc` for complex type specifications
      
      ## Type Specifications
      - Use `@type`, `@typep`, and `@spec` to document function interfaces
      - Define complex types at the top of the module
      - Use meaningful type names that describe the purpose

examples:
  - input: |
      defmodule MessyModule do
        import List
        import String
        import Enum
        
        def func1(x), do: x + 1
        
        def func3(x), do: private_helper(x) * 2
        
        defp private_helper(x), do: x + 5
        
        def func2(x), do: x - 1
      end
    output: |
      defmodule OrganizedModule do
        @moduledoc """
        This module handles organized operations.
        """
        
        import Enum, only: [map: 2]
        import List, only: [first: 1, last: 1]
        import String, only: [downcase: 1]
        
        @type input_value :: integer()
        @type result :: integer()
        
        @spec func1(input_value()) :: result()
        def func1(x), do: x + 1
        
        @spec func2(input_value()) :: result()
        def func2(x), do: x - 1
        
        @spec func3(input_value()) :: result()
        def func3(x), do: private_helper(x) * 2
        
        defp private_helper(x), do: x + 5
      end

metadata:
  priority: high
  version: 1.0
</rule> 
# Elixir Testing Practices

<rule>
name: elixir_testing
description: Best practices for testing Elixir applications using ExUnit and other testing tools
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Testing Best Practices

      ## Test Organization
      - Group related tests in test modules that mirror the production code structure
      - Use descriptive test names that explain the behavior being tested
      - Organize tests by functionality or feature
      - Keep test files and test cases focused and concise
      
      ## Test Setup
      - Use `setup` or `setup_all` blocks to prepare common test data
      - Consider using fixtures for complex test data
      - Clean up resources with `on_exit` callbacks
      - Use contexts to share test data between tests
      
      ## Test Assertions
      - Use specific assertions that clearly communicate intent (`assert_receive`, `assert_in_delta`, etc.)
      - Write one assertion per test when possible
      - Include helpful error messages in assertions
      - Test edge cases and error conditions, not just happy paths
      
      ## Mocking and Stubbing
      - Use Mox for mocking behaviors and interfaces
      - Prefer dependency injection to make code more testable
      - Consider using ExMachina for factory patterns
      - Use the built-in `ExUnit.CaptureLog` for testing logging
      
      ## Integration Tests
      - Use Phoenix.ConnTest for testing HTTP endpoints
      - Test your Ecto queries against an actual test database
      - Use sandbox mode for database tests to ensure isolation
      - Consider property-based testing with StreamData for complex input spaces
      
      ## Test Performance
      - Keep tests fast to encourage running them frequently
      - Use async: true to run tests in parallel when possible
      - Avoid unnecessary database operations or external API calls
      - Be mindful of test data volume
      
      ## Doctests
      - Use doctests for simple function examples
      - Keep doctests focused on demonstrating usage, not edge cases
      - Ensure doctests are up-to-date with the actual code behavior
      - Use doctests as living documentation

examples:
  - input: |
      defmodule MyApp.UserTest do
        use ExUnit.Case
        
        test "create user" do
          user = MyApp.User.create("John", "john@example.com")
          assert user.name == "John"
          assert user.email == "john@example.com"
          assert user.active == true
          assert user.created_at != nil
        end
      end
    output: |
      defmodule MyApp.UserTest do
        use ExUnit.Case, async: true
        alias MyApp.User
        
        describe "create/2" do
          test "creates a user with the given name and email" do
            user = User.create("John", "john@example.com")
            assert user.name == "John"
            assert user.email == "john@example.com"
          end
          
          test "sets default values for new users" do
            user = User.create("John", "john@example.com")
            assert user.active == true
            assert %DateTime{} = user.created_at
          end
          
          test "validates email format" do
            assert {:error, :invalid_email} = User.create("John", "invalid-email")
          end
        end
      end
  
  - input: |
      defmodule MyApp.PaymentTest do
        use ExUnit.Case
        
        test "process payment with external API" do
          # Makes actual API call to payment processor
          result = MyApp.Payment.process("4111111111111111", "123", "12/25", 100)
          assert result.status == "success"
        end
      end
    output: |
      defmodule MyApp.PaymentTest do
        use ExUnit.Case, async: true
        
        import Mox
        
        # Define mock in test_helper.exs:
        # Mox.defmock(MockPaymentAPI, for: MyApp.PaymentAPI.Behaviour)
        
        setup :verify_on_exit!
        
        describe "process/4" do
          test "processes a valid payment" do
            expect(MockPaymentAPI, :charge, fn card_number, cvv, expiry, amount ->
              assert card_number == "4111111111111111"
              assert cvv == "123"
              assert expiry == "12/25"
              assert amount == 100
              
              {:ok, %{id: "pay_123", status: "success"}}
            end)
            
            result = MyApp.Payment.process("4111111111111111", "123", "12/25", 100)
            assert result.status == "success"
          end
          
          test "handles API errors gracefully" do
            expect(MockPaymentAPI, :charge, fn _, _, _, _ ->
              {:error, :service_unavailable}
            end)
            
            assert {:error, :payment_failed} = MyApp.Payment.process("4111111111111111", "123", "12/25", 100)
          end
        end
      end

metadata:
  priority: high
  version: 1.0
</rule> 
# Elixir Process Design

<rule>
name: elixir_process_design
description: Best practices for designing process-based systems in Elixir
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Process Design Best Practices

      ## Process Organization
      - Implement a single process in one module
      - Assign exactly one parallel process to each truly concurrent activity
      - Each process should have only one "role" (server, client, worker, supervisor)
      - Use processes for structuring the system, not for basic abstraction
      
      ## Process Registration
      - Register processes with the same name as their module when appropriate
      - Only register processes that need a long lifespan
      - Use Registry or other mechanism for dynamic process lookup
      
      ## Message Protocol
      - Tag all messages for easier pattern matching and extensibility
      - Document message formats with typespecs where applicable
      - Flush unknown messages to prevent message queue buildup
      - Use timeout mechanisms appropriately, handling late messages
      
      ## Server Implementation
      - Write tail-recursive servers to prevent memory leaks
      - Use interface functions rather than direct message sends
      - Prefer OTP behaviors (GenServer, Supervisor, etc.) over raw processes
      - Keep state transformations explicit and easy to reason about
      
      ## Error Handling
      - Be intentional about trapping exits - processes should either always trap or never trap
      - Use supervisors for automatic process restarts
      - Apply the "Let it crash" philosophy for unexpected errors
      - Log errors appropriately before crashing
      
      ## Process Dictionary
      - Avoid the process dictionary (get/put) except in very specialized cases
      - Pass state explicitly between function calls instead

examples:
  - input: |
      # Raw process using spawn
      defmodule UserRegistry do
        def start do
          spawn(fn -> loop(%{}) end)
        end
        
        def register(registry, username, data) do
          send(registry, {:register, username, data})
        end
        
        def lookup(registry, username) do
          send(registry, {:lookup, username, self()})
          receive do
            result -> result
          after 1000 ->
            :timeout
          end
        end
        
        defp loop(state) do
          receive do
            {:register, username, data} ->
              loop(Map.put(state, username, data))
            {:lookup, username, pid} ->
              send(pid, Map.get(state, username))
              loop(state)
          end
        end
      end
    output: |
      defmodule UserRegistry do
        use GenServer
        
        # Client API
        def start_link(opts \\ []) do
          GenServer.start_link(__MODULE__, %{}, opts)
        end
        
        def register(registry, username, data) do
          GenServer.cast(registry, {:register, username, data})
        end
        
        def lookup(registry, username) do
          GenServer.call(registry, {:lookup, username})
        end
        
        # Server Callbacks
        @impl true
        def init(state) do
          {:ok, state}
        end
        
        @impl true
        def handle_cast({:register, username, data}, state) do
          {:noreply, Map.put(state, username, data)}
        end
        
        @impl true
        def handle_call({:lookup, username}, _from, state) do
          {:reply, Map.get(state, username), state}
        end
        
        # Catch unknown messages
        @impl true
        def handle_info(msg, state) do
          require Logger
          Logger.warn("Received unexpected message: #{inspect(msg)}")
          {:noreply, state}
        end
      end
      
      # Usage:
      {:ok, registry} = UserRegistry.start_link(name: UserRegistry)
      UserRegistry.register(registry, "alice", %{email: "alice@example.com"})
      user_data = UserRegistry.lookup(registry, "alice")
      
  - input: |
      defmodule MessageHandler do
        def process_messages(pid) do
          receive do
            {sender, msg} -> 
              handle_message(msg)
              sender ! {:ok, "Processed"}
              process_messages(pid)
            msg ->
              handle_message(msg)
              process_messages(pid)  
          end
        end
        
        defp handle_message(msg) do
          # Process message
        end
      end
    output: |
      defmodule MessageHandler do
        use GenServer
        
        def start_link(opts \\ []) do
          GenServer.start_link(__MODULE__, [], opts)
        end
        
        # Client API
        def send_message(server, msg) do
          GenServer.call(server, {:process, msg})
        end
        
        # Server Callbacks
        @impl true
        def init(_) do
          {:ok, []}
        end
        
        @impl true
        def handle_call({:process, msg}, from, state) do
          result = handle_message(msg)
          {:reply, {:ok, "Processed", result}, state}
        end
        
        # Handle unexpected messages
        @impl true
        def handle_info(msg, state) do
          require Logger
          Logger.warn("Received unexpected message: #{inspect(msg)}")
          {:noreply, state}
        end
        
        defp handle_message(msg) do
          # Process message
        end
      end

metadata:
  priority: high
  version: 1.0
</rule> 
# Elixir Testing Practices

<rule>
name: elixir_testing
description: Best practices for testing Elixir applications using ExUnit and other testing tools
filters:
  - type: file_extension
    pattern: "\\.ex$|\\.exs$"

actions:
  - type: suggest
    message: |
      # Elixir Testing Best Practices

      ## Test Organization
      - Group related tests in test modules that mirror the production code structure
      - Use descriptive test names that explain the behavior being tested
      - Organize tests by functionality or feature
      - Keep test files and test cases focused and concise
      
      ## Test Setup
      - Use `setup` or `setup_all` blocks to prepare common test data
      - Consider using fixtures for complex test data
      - Clean up resources with `on_exit` callbacks
      - Use contexts to share test data between tests
      
      ## Test Assertions
      - Use specific assertions that clearly communicate intent (`assert_receive`, `assert_in_delta`, etc.)
      - Write one assertion per test when possible
      - Include helpful error messages in assertions
      - Test edge cases and error conditions, not just happy paths
      
      ## Mocking and Stubbing
      - Use Mox for mocking behaviors and interfaces
      - Prefer dependency injection to make code more testable
      - Consider using ExMachina for factory patterns
      - Use the built-in `ExUnit.CaptureLog` for testing logging
      
      ## Integration Tests
      - Use Phoenix.ConnTest for testing HTTP endpoints
      - Test your Ecto queries against an actual test database
      - Use sandbox mode for database tests to ensure isolation
      - Consider property-based testing with StreamData for complex input spaces
      
      ## Test Performance
      - Keep tests fast to encourage running them frequently
      - Use async: true to run tests in parallel when possible
      - Avoid unnecessary database operations or external API calls
      - Be mindful of test data volume
      
      ## Doctests
      - Use doctests for simple function examples
      - Keep doctests focused on demonstrating usage, not edge cases
      - Ensure doctests are up-to-date with the actual code behavior
      - Use doctests as living documentation

examples:
  - input: |
      defmodule MyApp.UserTest do
        use ExUnit.Case
        
        test "create user" do
          user = MyApp.User.create("John", "john@example.com")
          assert user.name == "John"
          assert user.email == "john@example.com"
          assert user.active == true
          assert user.created_at != nil
        end
      end
    output: |
      defmodule MyApp.UserTest do
        use ExUnit.Case, async: true
        alias MyApp.User
        
        describe "create/2" do
          test "creates a user with the given name and email" do
            user = User.create("John", "john@example.com")
            assert user.name == "John"
            assert user.email == "john@example.com"
          end
          
          test "sets default values for new users" do
            user = User.create("John", "john@example.com")
            assert user.active == true
            assert %DateTime{} = user.created_at
          end
          
          test "validates email format" do
            assert {:error, :invalid_email} = User.create("John", "invalid-email")
          end
        end
      end
  
  - input: |
      defmodule MyApp.PaymentTest do
        use ExUnit.Case
        
        test "process payment with external API" do
          # Makes actual API call to payment processor
          result = MyApp.Payment.process("4111111111111111", "123", "12/25", 100)
          assert result.status == "success"
        end
      end
    output: |
      defmodule MyApp.PaymentTest do
        use ExUnit.Case, async: true
        
        import Mox
        
        # Define mock in test_helper.exs:
        # Mox.defmock(MockPaymentAPI, for: MyApp.PaymentAPI.Behaviour)
        
        setup :verify_on_exit!
        
        describe "process/4" do
          test "processes a valid payment" do
            expect(MockPaymentAPI, :charge, fn card_number, cvv, expiry, amount ->
              assert card_number == "4111111111111111"
              assert cvv == "123"
              assert expiry == "12/25"
              assert amount == 100
              
              {:ok, %{id: "pay_123", status: "success"}}
            end)
            
            result = MyApp.Payment.process("4111111111111111", "123", "12/25", 100)
            assert result.status == "success"
          end
          
          test "handles API errors gracefully" do
            expect(MockPaymentAPI, :charge, fn _, _, _, _ ->
              {:error, :service_unavailable}
            end)
            
            assert {:error, :payment_failed} = MyApp.Payment.process("4111111111111111", "123", "12/25", 100)
          end
        end
      end

metadata:
  priority: high
  version: 1.0
</rule> 