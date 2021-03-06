require 'spec_helper'

describe 'nova::scheduler::filter' do

  let :params do
    {}
  end

  shared_examples 'nova::scheduler::filter' do

    context 'with default parameters' do
      it { is_expected.to contain_nova_config('scheduler/max_attempts').with_value('3') }
      it { is_expected.to contain_nova_config('scheduler/periodic_task_interval').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/host_subset_size').with_value('1') }
      it { is_expected.to contain_nova_config('filter_scheduler/max_io_ops_per_host').with_value('8') }
      it { is_expected.to contain_nova_config('filter_scheduler/max_instances_per_host').with_value('50') }
      it { is_expected.to contain_nova_config('filter_scheduler/available_filters').with_value(['nova.scheduler.filters.all_filters']) }
      it { is_expected.to contain_nova_config('filter_scheduler/weight_classes').with_value('nova.scheduler.weights.all_weighers') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/enabled_filters').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/track_instance_changes').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/ram_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/cpu_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/disk_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/io_ops_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/soft_affinity_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/soft_anti_affinity_weight_multiplier').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/restrict_isolated_hosts_to_isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/aggregate_image_properties_isolation_namespace').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/aggregate_image_properties_isolation_separator').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to_not contain_nova_config('filter_scheduler/use_baremetal_filters') }
      it { is_expected.to_not contain_nova_config('filter_scheduler/baremetal_enabled_filters') }
      it { is_expected.to_not contain_nova_config('scheduler/host_manager') }
    end

    context 'when overriding params with non-empty arrays' do
      let :params do
        { :scheduler_max_attempts               => '4',
          :isolated_images                      => ['ubuntu1','centos2'],
          :isolated_hosts                       => ['192.168.1.2','192.168.1.3'],
          :scheduler_default_filters            => ['RetryFilter','AvailabilityZoneFilter'],
          :scheduler_available_filters          => ['nova_filter1','nova_filter2']
        }
      end

      it { is_expected.to contain_nova_config('scheduler/max_attempts').with_value('4') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_images').with_value('ubuntu1,centos2') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_hosts').with_value('192.168.1.2,192.168.1.3') }
      it { is_expected.to contain_nova_config('filter_scheduler/enabled_filters').with_value('RetryFilter,AvailabilityZoneFilter') }
      it { is_expected.to contain_nova_config('filter_scheduler/available_filters').with_value(['nova_filter1','nova_filter2']) }
    end

    context 'when overriding deprecated params' do
      let :params do
        {
          :scheduler_use_baremetal_filters      => true,
          :baremetal_scheduler_default_filters  => ['ExactRamFilter','ExactDiskFilter','ExactCoreFilter'],
        }
      end

      it { is_expected.to_not contain_nova_config('filter_scheduler/use_baremetal_filters') }
      it { is_expected.to_not contain_nova_config('filter_scheduler/baremetal_enabled_filters') }
    end

    context 'when overriding params with empty arrays' do
      let :params do
        { :isolated_images                      => [],
          :isolated_hosts                       => [],
          :scheduler_available_filters          => [],
          :scheduler_default_filters            => [],
        }
      end

      it { is_expected.to contain_nova_config('filter_scheduler/isolated_images').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/isolated_hosts').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/available_filters').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('filter_scheduler/enabled_filters').with_value('<SERVICE DEFAULT>') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::scheduler::filter'
    end
  end

end
