class Task < ApplicationRecord
  enum :status, {
    created: "created",
    in_progress: "in-progress",
    done: "done",
    pending: "pending",
    cancel: "cancel"
  }

  enum :priority, {
    low: "low",
    mid: "mid",
    high: "high"
  }
end
