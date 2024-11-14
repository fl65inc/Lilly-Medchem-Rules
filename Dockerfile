FROM gcc

# Install dependencies for RVM and Ruby
RUN apt-get update && apt-get install -y curl gnupg2 awscli

# Import RVM keys
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -

# Install RVM
RUN curl -L https://get.rvm.io | bash -s stable

# Set up environment variables for RVM
ENV PATH /usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-3.3.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/profile

# Install Ruby
RUN /bin/bash -l -c "source /etc/profile && rvm install ruby-3.3.0"

# Copy the application code
COPY . /Lilly-Medchem-Rules
WORKDIR /Lilly-Medchem-Rules

# Build the application
RUN make

# Run tests (optional)
RUN /bin/bash -l -c "source /etc/profile && rvm use 3.3.0 && make test"


# Set the entrypoint
CMD /bin/bash -c "source /etc/profile && rvm use 3.3.0 && ./Lilly_Medchem_Rules.rb -i smi -"