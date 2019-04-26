Puppet::Type.newtype(:graylog_dashboard_widget) do

  desc <<-END_OF_DOC
    @summary
      Creates an Dashboard Widget.

    The title of this resource should be the name of the dashboard on which the
    widget appears, followed by !!!, followed by the name of the widget.
      
    @see graylog_dashboard
    @see graylog_dashboard_layout

    @example
      graylog_dashboard_widget { 'Example Dashboard!!!Example Widget':
        ensure        => present,
        cache_time    => 10,
        config        => {
          field          => 'example_field',
          limit          => 5,
          sort_order     => 'desc',
          stacked_fields => '',
          timerange      => {
            range => 86400,
            type  => 'relative',
          },
          query          => 'foo:bar',
        },
        type          => 'QUICKVALUES_HISTOGRAM',
      }
  END_OF_DOC

  ensurable

  def name
    "#{self[:dashboard]}!!!#{self[:name]}"
  end

  newparam(:name) do
    desc 'The name of the dashboard widget.'
    isnamevar
  end

  newparam(:dashboard) do
    desc 'The dashboard on which this widget appears.'
    isnamevar
  end

  newproperty(:cache_time) do
    desc 'The amount of time (in seconds) this widget should cache data before requesting new data.'
  end

  newproperty(:config) do
    desc 'A hash of configuration values for the widget. Structure of the hash varies by widget type.'
  end

  newproperty(:type) do
    desc 'The type of widget.'
  end

  def self.title_patterns
    [
      [ /(^(?!.*!!!))/m,
        [ [:name] ] ],
      [ /^(.+)!!!(.+)$/,
        [ [:dashboard], [:name] ]
      ]
    ]
  end

  autorequire('file') { 'graylog_api_config.yaml' }
  autorequire('graylog_dashboard') { self[:dashboard] }
end
